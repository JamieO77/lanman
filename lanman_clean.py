# clean.py - run daily from cron, obeys network_options
import mysql.connector
import os
import sys
from datetime import datetime

db_config = {
    'host': '192.168.1.15',
    'port': 3308,
    'user': 'root',
    'password': 'jamieo',
    'database': 'lanman'
}

LOCK_FILE = '/tmp/lanman_cleaner.lock'

def print_log(msg):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}")

def db_log(conn, cursor, msg, is_error=False):
    """Saves script history directly to the database so you can view it in the portal."""
    prefix = "[ERROR]" if is_error else "[INFO]"
    full_msg = f"{prefix} Cleanup Script: {msg}"
    print_log(full_msg)
    try:
        cursor.execute("INSERT INTO network_error_log (error_message, error_time) VALUES (%s, NOW())", (full_msg,))
        conn.commit()
    except Exception:
        pass

def cleanup():
    # 1. The Safety Lock
    if os.path.exists(LOCK_FILE):
        print_log("Cleanup is already running. Exiting to prevent overlap.")
        sys.exit(0)

    try:
        open(LOCK_FILE, 'w').close()
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM network_options LIMIT 1")
        opt = cursor.fetchone() or {}

        if not opt.get('enable_clean', 0):
            db_log(conn, cursor, "Cleanup is turned off in options. Exiting.")
            cursor.close()
            conn.close()
            return

        days = opt.get('clean_days', 7)
        db_log(conn, cursor, f"Starting daily routine. Keeping the last {days} days of history.")

        # Main log tables mapped to their specific timestamp columns
        log_tables = [
            ("network_log", "check_time"),
            ("network_health_log", "check_time"),
            ("monitor_logs", "checked_at"),
            ("network_speed_log", "check_time"),
            ("network_traces", "check_time"),
            ("network_alerts", "sent_at"),
            ("network_error_log", "error_time") # Cleans its own history so it doesn't bloat
        ]

        total_deleted = 0
        tables_to_optimize = []

        # 2. Room-by-Room Deletion & Saving
        for table, col in log_tables:
            try:
                cursor.execute(f"DELETE FROM {table} WHERE {col} < NOW() - INTERVAL %s DAY", (days,))
                deleted = cursor.rowcount
                conn.commit()
                total_deleted += deleted
                tables_to_optimize.append(table)
                print_log(f"Cleaned {deleted} rows from {table}")
            except Exception as e:
                db_log(conn, cursor, f"Failed to clean {table}: {str(e)}", is_error=True)

        # 3. Optional Discovery Cleanup
        if opt.get('clean_discovery', 0):
            try:
                cursor.execute("""
                    DELETE FROM network_discovery 
                    WHERE last_seen < NOW() - INTERVAL %s DAY 
                    AND is_ignored = 0
                """, (days,))
                deleted = cursor.rowcount
                conn.commit()
                total_deleted += deleted
                tables_to_optimize.append("network_discovery")
                print_log(f"Cleaned {deleted} old devices from network_discovery")
            except Exception as e:
                db_log(conn, cursor, f"Failed to clean discovery: {str(e)}", is_error=True)

        # 4. Squeeze the Sponge (Optimize)
        if tables_to_optimize and total_deleted > 0:
            try:
                print_log("Optimizing tables to reclaim hard drive space...")
                optimize_query = "OPTIMIZE TABLE " + ", ".join(tables_to_optimize)
                cursor.execute(optimize_query)
                # Fetching all results is required to cleanly finish an OPTIMIZE TABLE command
                cursor.fetchall() 
                print_log("Optimization complete.")
            except Exception as e:
                db_log(conn, cursor, f"Optimization failed: {str(e)}", is_error=True)

        # Final Success Log
        db_log(conn, cursor, f"Successfully finished. Removed {total_deleted} old records and reclaimed space.")

        cursor.close()
        conn.close()

    except Exception as e:
        print_log(f"Critical Cleanup Error: {str(e)}")
        # If the DB connection is still open, try to log the critical crash
        if 'conn' in locals() and conn.is_connected():
            db_log(conn, cursor, f"Script crashed completely: {str(e)}", is_error=True)

    finally:
        # Always unlock the door when finished or if a major crash happens
        if os.path.exists(LOCK_FILE):
            os.remove(LOCK_FILE)

if __name__ == "__main__":
    cleanup()
