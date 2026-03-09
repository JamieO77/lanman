import mysql.connector
import subprocess
import requests
import xml.etree.ElementTree as ET
import re
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
import paramiko
from netmiko import ConnectHandler
import threading
import os
import sys
import socket
import ssl

db_config = {'host': '192.168.1.15', 'port': 3308, 'user': 'root', 'password': 'jamieo', 'database': 'lanman'}
LOCK_FILE = '/tmp/lanman_scanner.lock'

def print_log(msg):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}")

def log_error(conn, cursor, msg):
    print_log(f"Error: {msg}")
    try:
        cursor.execute("INSERT INTO network_error_log (error_message, error_time) VALUES (%s, NOW())", (msg,))
        conn.commit()
    except Exception as inner_e:
        print_log(f"CRITICAL: Could not log error to DB - {inner_e}")

def get_options(conn, cursor):
    print_log("Loading options")
    cursor.execute("SELECT * FROM network_options LIMIT 1")
    return cursor.fetchone() or {}

def send_notify(opt, conn, cursor, msg, notify_type, ip=None, hostname=None):
    print_log(f"Notify: {msg} (type={notify_type})")
    cursor.execute("INSERT INTO network_alerts (ip_address, hostname, alert_type, message, sent_at) VALUES (%s, %s, %s, %s, NOW())", (ip, hostname, notify_type, msg))
    
    if opt.get('enable_telegram') and opt.get(f'tg_notify_{notify_type}'):
        try:
            requests.get(f"https://api.telegram.org/bot{opt['telegram_token']}/sendMessage?chat_id={opt['telegram_chat_id']}&text={msg}")
        except Exception as e:
            log_error(conn, cursor, f"Telegram fail: {e}")
            
    if opt.get('enable_email') and opt.get(f'email_notify_{notify_type}'):
        try:
            m = MIMEText(msg)
            m['Subject'] = 'Network Alert'
            m['From'] = opt['smtp_user']
            m['To'] = opt['email_address']
            s = smtplib.SMTP(opt['smtp_host'], opt['smtp_port'])
            if opt['smtp_secure'] == 'tls': s.starttls()
            s.login(opt['smtp_user'], opt['smtp_pass'])
            s.sendmail(opt['smtp_user'], opt['email_address'], m.as_string())
            s.quit()
        except Exception as e:
            log_error(conn, cursor, f"Email fail: {e}")
            
    conn.commit()

def get_latency(ip, timeout, os_type):
    param = '-n' if os_type == 'windows' else '-c'
    timeout_param = '-w' if os_type == 'windows' else '-W'
    cmd = ['ping', param, '1', timeout_param, str(timeout), ip]
    try:
        out = subprocess.check_output(cmd, universal_newlines=True)
        ms_match = re.search(r'time[=<](\d+\.?\d*) ?ms', out)
        ms = float(ms_match.group(1)) if ms_match else 0.0
        return ms, 'online'
    except:
        return 0.0, 'offline'

def check_http(target, expected_code, timeout):
    try:
        r = requests.get(target if target.startswith('http') else f"http://{target}", timeout=timeout)
        return r.status_code == expected_code
    except:
        return False

def check_ssl(hostname):
    try:
        context = ssl.create_default_context()
        with socket.create_connection((hostname, 443), timeout=5) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                expiry = datetime.strptime(cert['notAfter'], '%b %d %H:%M:%S %Y %Z').date()
                return expiry
    except:
        return None

def get_system_load():
    try:
        return os.getloadavg()
    except AttributeError:
        return [0.0, 0.0, 0.0]

# --- DISCOVERY ---

def threaded_discovery(chunk, opt, os_type):
    thread_conn = mysql.connector.connect(**db_config)
    thread_cursor = thread_conn.cursor(dictionary=True)
    try:
        cmd = ["/usr/bin/nmap", "-sn", "-PE", "-PP", "-PM", "--min-parallelism", "50", "--max-retries", "1", "-T4", "-oX", "-", chunk]
        out = subprocess.check_output(cmd, timeout=opt.get('discovery_timeout_min', 3)*60).decode()
        root = ET.fromstring(out)
        
        thread_cursor.execute("SELECT id, ip_address, status, hostname, avg_latency, total_checks FROM network_assets")
        assets = {a['ip_address']: a for a in thread_cursor.fetchall()}
        
        for host in root.findall('host'):
            if host.find('status').get('state') != 'up': continue
            ip = host.find("./address[@addrtype='ipv4']").get('addr')
            if ip.endswith('.0') or ip.endswith('.255'): continue
            
            t_el = host.find('times')
            srtt = t_el.get('srtt') if t_el else None
            latency_ms = int(round(float(srtt)/1000)) if srtt else 1
            if latency_ms == 0: latency_ms = 1
            
            if ip in assets:
                asset = assets[ip]
                new_avg = latency_ms
                if asset.get('total_checks', 0) > 0:
                    new_avg = ((asset['avg_latency'] * asset['total_checks'] + latency_ms) / (asset['total_checks'] + 1))
                thread_cursor.execute("""
                    UPDATE network_assets SET status='online', last_latency=%s, avg_latency=%s, 
                    total_uptime_minutes=total_uptime_minutes + (%s/60), total_checks=total_checks+1, last_check=NOW() 
                    WHERE id=%s
                """, (latency_ms, new_avg, opt.get('ping_rate_seconds', 60), asset['id']))
                
                log_type = 'latency_high' if latency_ms > opt.get('latency_threshold_ms', 200) else 'latency_normal'
                thread_cursor.execute("INSERT INTO network_log (asset_id, ip_address, status, latency, log_type) VALUES (%s, %s, %s, %s, %s)", 
                                      (asset['id'], ip, 'online', latency_ms, log_type))
            else:
                thread_cursor.execute("""
                    INSERT IGNORE INTO network_discovery (ip_address, hostname, mac_address, vendor, first_seen, last_seen, status, latency) 
                    VALUES (%s, 'Unknown', '00:00:00:00:00:00', 'Unknown', NOW(), NOW(), 'online', %s)
                """, (ip, latency_ms))
        thread_conn.commit()
    except Exception as e:
        log_error(thread_conn, thread_cursor, f"Thread {chunk} error: {e}")
    finally:
        thread_cursor.close()
        thread_conn.close()

def discovery_scan(opt, conn, cursor, os_type):
    if not opt.get('enable_discovery'): return
    if opt.get('check_load', 0) and max(get_system_load()) > opt.get('max_load_threshold', 80): return
    
    print_log("Discovery start")
    if opt.get('discovery_parallel', 0):
        threads = []
        num_threads = opt.get('discovery_max_threads', 10)
        for i in range(num_threads):
            start = i * (256 // num_threads)
            end = (i + 1) * (256 // num_threads) - 1
            chunk = f"192.168.1.{start}-{end}" if end > start else f"192.168.1.{start}"
            t = threading.Thread(target=threaded_discovery, args=(chunk, opt, os_type))
            threads.append(t)
            t.start()
        for t in threads:
            t.join()
    else:
        threaded_discovery("192.168.1.0/24", opt, os_type)

# --- PORT SCANNING & ENRICHMENT ---

def enrich_scan(opt, conn, cursor):
    if not opt.get('enable_enhance'): return
    print_log("Enrich start")
    
    query = """SELECT id, ip_address FROM network_assets WHERE enriched = 0"""
    cursor.execute(query)
    assets = cursor.fetchall()
    
    for asset in assets:
        ip = asset['ip_address']
        asset_id = asset['id']
        try:
            # -sV detects service versions, --top-ports 100 limits the scan to be fast
            out = subprocess.check_output(["/usr/bin/nmap", "-sV", "--top-ports", "100", "-T4", "-oX", "-", ip], text=True)
            root = ET.fromstring(out)
            
            name, mac, ven = "unknown", "00:00:00:00:00:00", "unknown"
            
            for host in root.findall('host'):
                hostnames = host.find('hostnames')
                if hostnames is not None and hostnames.find('hostname') is not None:
                    name = hostnames.find('hostname').get('name')
                
                for addr in host.findall('address'):
                    if addr.get('addrtype') == 'mac':
                        mac = addr.get('addr').lower()
                        ven = addr.get('vendor') or 'unknown'

                # Read open ports and insert into database
                ports = host.find('ports')
                if ports is not None:
                    for port in ports.findall('port'):
                        state = port.find('state')
                        if state is not None and state.get('state') == 'open':
                            portid = port.get('portid')
                            service_el = port.find('service')
                            svc_name = service_el.get('name') if service_el is not None else 'unknown'
                            is_https = 1 if 'ssl' in (service_el.get('tunnel') or '') or svc_name == 'https' else 0
                            
                            # Insert the service
                            cursor.execute("""
                                INSERT IGNORE INTO network_services (asset_id, service_name, port_number, https, status) 
                                VALUES (%s, %s, %s, %s, 'online')
                                ON DUPLICATE KEY UPDATE status='online'
                            """, (asset_id, svc_name, portid, is_https))
                            
                            # Log the newly found service history
                            log_msg = f"Port {portid} ({svc_name}) discovered open"
                            cursor.execute("""
                                INSERT INTO network_activity_log (asset_id, activity_type, description, severity) 
                                VALUES (%s, 'port_discovery', %s, 'info')
                            """, (asset_id, log_msg))

            cursor.execute("UPDATE network_assets SET hostname=%s, mac_address=%s, vendor=%s, last_seen=NOW(), enriched=1 WHERE id=%s", (name, mac, ven, asset_id))
            print_log(f"Enriched {ip} - Services Logged")
        except Exception as e:
            log_error(conn, cursor, f"Enrich failed {ip}: {e}")
            
    conn.commit()

# --- MONITORING & HEALTH ---

def monitor_cycle(opt, conn, cursor, os_type):
    if not opt.get('enable_monitoring'): return
    print_log("Monitor cycle start")
    cursor.execute("SELECT * FROM monitor_nodes WHERE is_active=1 AND (last_check_at IS NULL OR last_check_at <= NOW() - INTERVAL check_interval_mins MINUTE)")
    nodes = cursor.fetchall()
    
    for node in nodes:
        latency, status = get_latency(node['target_address'], node['timeout_seconds'], os_type)
        is_up = status == 'online'
        msg = "OK"
        
        if node['monitor_http_status']:
            if not check_http(node['target_address'], node['expected_http_code'], node['timeout_seconds']):
                is_up = False
                msg = "HTTP mismatch"
                
        ssl_date = None
        if node['monitor_ssl']:
            host = node['target_address'].replace('https://', '').replace('http://', '').split('/')[0]
            ssl_date = check_ssl(host)
            if ssl_date and (ssl_date - datetime.now().date()).days < 30:
                send_notify(opt, conn, cursor, f"SSL expiry soon {node['target_address']}", 'failure', node['target_address'], node['node_name'])
                
        new_fail = 0 if is_up else node['fail_count_current'] + 1
        new_status = 'online' if is_up else 'offline'
        
        if not is_up and new_fail == node['fail_count_threshold']:
            send_notify(opt, conn, cursor, f"{node['node_name']} down: {msg}", 'failure', node['target_address'], node['node_name'])
            
        cursor.execute("UPDATE monitor_nodes SET current_status=%s, fail_count_current=%s, last_check_at=NOW(), ssl_expiry_date=%s, last_online_at=IF(%s='online', NOW(), last_online_at) WHERE id=%s", (new_status, new_fail, ssl_date, new_status, node['id']))
        cursor.execute("INSERT INTO monitor_logs (node_id, latency_ms, status) VALUES (%s, %s, %s)", (node['id'], latency, new_status))
    conn.commit()

def run_all_health_checks(opt, conn, cursor):
    cursor.execute("SELECT * FROM network_assets WHERE health_check_method != 'none' AND status = 'online'")
    assets = cursor.fetchall()
    for asset in assets:
        health_check_single(asset, conn, cursor, opt)

def health_check_single(asset, conn, cursor, opt):
    cursor.execute("SELECT * FROM network_logins WHERE parent_id=%s AND parent_type='asset'", (asset['id'],))
    logins = cursor.fetchall()
    cpu, ram, disk = 0, 0, 0
    
    if asset['health_check_method'] == 'snmp':
        community = next((l['password'] for l in logins if l['is_snmp']), opt.get('default_snmp_community', 'public'))
        def snmp_get(oid):
            cmd = ['snmpget', '-v', '2c', '-c', community, f"{asset['ip_address']}:161", oid]
            try:
                out = subprocess.check_output(cmd, timeout=10, text=True)
                val = re.sub(r'[^0-9.]', '', out.split('=')[-1])
                return float(val) if val else 0.0
            except:
                return 0.0
                
        cpu_load = snmp_get('.1.3.6.1.4.1.2021.10.1.3.1')
        ram_total = snmp_get('.1.3.6.1.4.1.2021.4.5.0')
        ram_free = snmp_get('.1.3.6.1.4.1.2021.4.6.0')
        disk_pct = snmp_get('.1.3.6.1.4.1.2021.9.1.9.1')
        
        cpu = int(cpu_load / 100) if cpu_load else 0
        ram = int(100 - (ram_free / ram_total * 100)) if ram_total > 0 else 0
        disk = int(disk_pct)

    elif asset['health_check_method'] == 'paramiko':
        login = next((l for l in logins if not l['is_snmp']), None)
        if login:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            try:
                client.connect(asset['ip_address'], username=login['username'], password=login['password'], timeout=5)
                if asset['os_type'] == 'linux':
                    _, out, _ = client.exec_command(r"top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'")
                    cpu = float(out.read().decode().strip() or 0)
                    _, out, _ = client.exec_command(r"free -m | awk '/Mem/ {printf \"%.0f\", 100 - $7/$2 * 100}'")
                    ram = int(out.read().decode().strip() or 0)
                    _, out, _ = client.exec_command(r"df -h / | awk 'NR==2 {gsub(\"%\", \"\", $5); print $5}'")
                    disk = int(out.read().decode().strip() or 0)
                client.close()
            except Exception as e:
                log_error(conn, cursor, f"Paramiko {asset['ip_address']}: {e}")

    elif asset['health_check_method'] == 'netmiko':
        login = next((l for l in logins if not l['is_snmp']), None)
        if login:
            device = {
                'device_type': asset['vendor'].lower() if 'cisco' in asset['vendor'].lower() else asset['os_type'],
                'host': asset['ip_address'],
                'username': login['username'],
                'password': login['password']
            }
            try:
                with ConnectHandler(**device) as net_connect:
                    if 'cisco' in asset['vendor'].lower():
                        cpu_out = net_connect.send_command('show processes cpu')
                        cpu_match = re.search(r'five seconds: (\d+)%', cpu_out)
                        cpu = int(cpu_match.group(1)) if cpu_match else 0
                        
                        mem_out = net_connect.send_command('show memory statistics')
                        ram_match = re.search(r'Processor\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)', mem_out)
                        ram = int(ram_match.group(1)) if ram_match else 0
                        
                        disk_out = net_connect.send_command('show file systems')
                        disk_match = re.search(r'\*?\s+\d+\s+\d+\s+(\d+)%', disk_out)
                        disk = int(disk_match.group(1)) if disk_match else 0
            except Exception as e:
                log_error(conn, cursor, f"Netmiko {asset['ip_address']}: {e}")

    cursor.execute("UPDATE network_assets SET cpu_usage=%s, ram_usage=%s, disk_usage=%s WHERE id=%s", (cpu, ram, disk, asset['id']))
    cursor.execute("INSERT INTO network_health_log (asset_id, cpu_usage, ram_usage, disk_usage) VALUES (%s, %s, %s, %s)", (asset['id'], cpu, ram, disk))
    conn.commit()

def trace_assets(opt, conn, cursor, os_type):
    print_log("Trace start")
    cursor.execute("SELECT id, ip_address, 'asset' AS source FROM network_assets WHERE asset_trace=1 UNION SELECT id, ip_address, 'discovery' AS source FROM network_discovery WHERE asset_trace=1")
    for item in cursor.fetchall():
        cursor.execute("DELETE FROM network_traces WHERE target_id=%s AND source_type=%s", (item['id'], item['source']))
        cmd = ['traceroute', '-d', '-m', '5', item['ip_address']] if os_type == 'linux' else ['tracert', '-d', '-h', '5', item['ip_address']]
        try:
            out = subprocess.check_output(cmd, universal_newlines=True, timeout=30)
            hop_num = 1
            for line in out.splitlines():
                match = re.search(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})', line)
                if match:
                    hop_ip = match.group(1)
                    ms_match = re.search(r'(\d+)\s*ms', line)
                    latency = int(ms_match.group(1)) if ms_match else 0
                    cursor.execute("INSERT INTO network_traces (target_id, source_type, hop_position, hop_ip, latency_ms, check_time) VALUES (%s, %s, %s, %s, %s, NOW())", (item['id'], item['source'], hop_num, hop_ip, latency))
                    hop_num += 1
        except:
            pass
    conn.commit()

if __name__ == "__main__":
    # 1. The "Do Not Disturb" Lock System for Cron
    if os.path.exists(LOCK_FILE):
        print("Script is already running. Exiting to prevent overlap.")
        sys.exit(0)
        
    try:
        # Create lock file
        open(LOCK_FILE, 'w').close()
        
        print_log("Script started by Cron")
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        opt = get_options(conn, cursor)
        os_type = opt.get('host_os', 'linux')
        
        print_log("=== Execution cycle started ===")
        discovery_scan(opt, conn, cursor, os_type)
        enrich_scan(opt, conn, cursor)
        monitor_cycle(opt, conn, cursor, os_type)
        run_all_health_checks(opt, conn, cursor)
        trace_assets(opt, conn, cursor, os_type)
        print_log("=== Execution finished successfully ===")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print_log(f"Execution failed - {e}")
        
    finally:
        # Always remove the lock file when done or if it crashes
        if os.path.exists(LOCK_FILE):
            os.remove(LOCK_FILE)
