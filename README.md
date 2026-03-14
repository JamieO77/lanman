🛰️ LanMan V.3: Infrastructure Command & Intelligence

LANMAN is a centralized, high-security command station designed for comprehensive network infrastructure and asset management. Engineered on a highly optimized web stack (PHP 8.2, MySQL 8.0, Scriptcase 9+), it functions as a secure, single-pane-of-glass interface for your entire local area network. It empowers administrators to monitor, diagnose, and actively manage remote nodes—ranging from IP surveillance cameras to headless Linux servers—directly from the browser, entirely eliminating the need for localized management clients or VPN tunneling. LanMan is a centralized, high-security command station for network infrastructure and asset management.

### 🚀 Core Capabilities

* **Autonomous Network Reconnaissance:** Operates a headless Python 3.11 discovery engine (`scan.py` and `cleanup.py`) utilizing raw ARP and ICMP sockets to continuously map the physical data-link layer. It automatically detects rogue devices, tracks dynamic DHCP allocations, and dynamically purges stale host records.
* **Unified Asset Intelligence:** A high-performance MySQL 8 backend serves as the immutable "Single Source of Truth." It securely warehouses hardware MAC addresses, IP allocation histories, vendor metadata, and encrypted device credentials utilizing strict relational database structures.
* **Zero-Footprint Administration:** Execute deep-dive network diagnostics directly through the web interface. Capabilities include an embedded SSH terminal for secure server administration, raw TCP/UDP port scanning, and active service enumeration without deploying local software agents.
* **Surveillance & Media Integration:** Natively decodes and manages diverse multimedia streams. Features built-in ONVIF protocol support for automated IP camera discovery, active web-based PTZ (Pan-Tilt-Zoom) mechanical control, and localized RTSP/MJPEG video stream proxying.
* **Real-Time Telemetry & Heartbeat:** Automated Python and PHP workers execute continuous ICMP health checks across all registered infrastructure nodes. The platform captures granular latency metrics and uptime persistence, allowing administrators to immediately identify network degradation or hardware failures.
* 
<img width="1967" height="1241" alt="image" src="https://github.com/user-attachments/assets/d73704f1-bce4-4911-b25e-b316c94de435" />

## 🛠️ Integrated Diagnostic & Management Toolset

### 1. Advanced Network Diagnostic Suite
* **Function:** A comprehensive, hardware-level utility matrix executing raw TCP/UDP port enumeration, ICMP latency tracking, and routing hop analysis (Traceroute) directly from the Scriptcase frontend.
* **Operational Example:** If a critical Linux server stops responding to application requests, an administrator can instantly trigger a localized Nmap port scan from the dashboard to verify if SSH (Port 22) or HTTP (Port 80) sockets are actively listening, isolating the failure domain before initiating a reboot.

### 2. Autonomous Discovery & Asset Ingestion
* **Function:** The web-facing interface for the Python-driven `scan.py` backend. It visualizes raw ARP and ICMP broadcast results, resolving MAC addresses to physical hardware vendors (OUI) and identifying unauthorized subnet intrusions.
* **Operational Example:** When the automated hourly cron job detects a newly connected device, it surfaces in the Discovery queue. The administrator can review the node's exposed ports and execute a single-click "Import," migrating the device into the permanent MySQL asset inventory with assigned ownership metadata and static IP tagging.

### 3. Surveillance Command (IP Camera Node)
* **Function:** A low-latency, proxy-routed viewing portal for RTSP and MJPEG video streams, featuring native ONVIF protocol integration for hardware manipulation.
* **Operational Example:** Administrators can monitor a live security feed while simultaneously utilizing the on-screen PTZ (Pan-Tilt-Zoom) directional overlay to manipulate the camera's mechanical lens. Real-time telemetry, including ping latency and node uptime, is overlaid directly onto the viewing matrix.

### 4. Web-Based Secure Terminal (SSH Console)
* **Function:** A zero-footprint, browser-integrated secure shell (SSH) emulator utilizing the platform's encrypted MySQL credential vault to authenticate against remote infrastructure.
* **Operational Example:** Administrators can securely access a remote Linux server's command line to restart stalled daemon services, flush DNS caches, or modify configuration files entirely within the web browser, eliminating the need for localized clients like PuTTY or exposed VPN tunnels.

### 5. Sandboxed Document & Media Viewer
* **Function:** A server-side rendering engine (utilizing libraries like PDF.js and Mammoth.js) designed to enforce a strict "zero-download" security policy. It proxies and visualizes files residing on secure network storage directly into the browser DOM.
* **Operational Example:** An administrator can instantly review an uploaded PDF network topology diagram, parse a `.docx` incident report, or scrub through an `.mp4` surveillance export securely within the platform's isolated sandbox, preventing potential malware execution or sensitive data leakage to the local workstation.

### 6. Dynamic IP Address Management (IPAM)
* **Function:** A localized tracking engine that maps DHCP lease lifecycles and static IP reservations against known MAC addresses, providing a visual heatmap of subnet utilization.
* **Operational Example:** Before provisioning a new bare-metal server, an administrator can consult the IPAM grid to identify a block of historically unassigned IP addresses, ensuring no localized IP conflicts occur during deployment.

### 7. Automated Alerting & Webhook Engine
* **Function:** A reactive notification subsystem that triggers outbound webhooks (e.g., Telegram, Discord, or internal ticketing systems) when the Python health checker detects critical infrastructure state changes.
* **Operational Example:** If a core network switch drops offline and fails three consecutive ICMP heartbeat checks, the engine immediately dispatches a high-priority push notification containing the node's IP, physical location tag, and downtime duration directly to the engineering team.

## AND SO MUCH MORE....

## 🚀 Portal Screenshots

* Dashboard
<img width="2288" height="1356" alt="image" src="https://github.com/user-attachments/assets/f7242af5-350a-423f-9066-502f948185cf" />

* Network Map:
<img width="2315" height="1360" alt="image" src="https://github.com/user-attachments/assets/b5c0fb2a-206d-43d5-8418-1f72ae7c3861" />

* Network Analysis:
<img width="1902" height="1343" alt="image" src="https://github.com/user-attachments/assets/e3f554fd-f48c-4323-9dac-4d2adc0e0db5" />

* Network/Portal Logs:
<img width="1802" height="1041" alt="image" src="https://github.com/user-attachments/assets/79d6508f-93cc-4732-a80a-fc29a4cce2fc" />

* Network Overviews:
<img width="1768" height="1027" alt="image" src="https://github.com/user-attachments/assets/e7908385-a98b-484a-8a1c-bc8dd68a9b64" />

* Network Cameras:
<img width="1947" height="647" alt="image" src="https://github.com/user-attachments/assets/94141bdc-2b0c-49f7-9542-5d7aef63aac9" />

* Network Tools:
<img width="210" height="1157" alt="image" src="https://github.com/user-attachments/assets/3c9833da-7998-4513-af63-7828cf568546" />

* AND SO MUCH MORE!!!!
  
## 🔧 Full System Explanation: Lanman Network Discovery Platform

**1. Autonomous Network Reconnaissance (Backend Engine)**
Lanman operates a headless, automated Python discovery engine that interfaces directly with your physical network layer to maintain an accurate inventory of connected assets.
* *Active Scanning Protocol:* Utilizing `scapy` and `python-nmap`, the `scan.py` daemon continuously broadcasts raw ARP and ICMP packets across the subnet. This allows it to identify active hosts, MAC addresses, and hardware vendors at the data-link layer, bypassing standard OS-level firewall restrictions that block standard ping requests.
* *State Management & Sanitization:* The automated `cleanup.py` script acts as a localized garbage collector. It routinely scans the MySQL database and purges stale device records if a host fails to respond to network sweeps over a predefined chronological threshold, ensuring the platform strictly reflects the real-time network topology.

**2. Centralized Asset Database (Storage Layer)**
All discovered network telemetry is strictly normalized and routed into a dedicated MySQL 8 relational database (`lanman_db`). This layer maintains historical MAC-to-IP mappings, device metadata, and network uptime statistics utilizing best-practice lowercase and underscore schema naming conventions. It acts as the single source of truth for the entire platform.

**3. Administration & Visualization Console (Frontend UI)**
The user-facing platform is a highly optimized, compiled Scriptcase PHP 8.2 web application.
* *Real-Time Asset Dashboard:* Translates raw database metrics into an interactive graphical interface. It allows network administrators to monitor subnet saturation, identify unauthorized rogue devices connecting to the LAN, and track dynamic DHCP IP allocations.
* *Device Management:* Provides an interactive grid architecture to manually tag known devices with physical locations, assign ownership, designate static IP reservations, and monitor the online/offline status of critical infrastructure nodes.

## 🔧 Portal & Script Capabilities/Tools
1. DASHBOARDS & MONITORING (Core Views)
  * dash_main: The primary system dashboard showing global health.
  * dash_noc: Network Operations Center view for high-level monitoring.
  * dash_assets: Overview dashboard specifically for hardware status.
  * monitor_live: Real-time ping/status monitoring interface.
  * monitor_logs: Historical archive of all network events and changes.

2. ASSET MANAGEMENT (Inventory)
  * grid_network_assets: The main searchable list of all devices.
  * form_network_assets: The editor for adding/modifying device details (where we added the telemetry).
  * form_asset_types: Categorization tool (e.g., Server, Camera, Switch).
  * grid_asset_locations: Physical mapping of where hardware is installed.

3. SURVEILLANCE & MEDIA (Camera Tools)
  * app_cam_viewer: The single-camera inspection app we just optimized.
  * grid_cam_multi: A "Matrix" view for watching multiple feeds at once.
  * form_cam_config: Specific settings for RTSP/MJPEG paths and ports.
  * app_nvr_bridge: Integration tool for connecting to external recording storage.

4. DIAGNOSTICS & TERMINAL (Remote Tools)
  * app_terminal_ssh: Web-based SSH console for remote Linux management.
  * app_port_scanner: Internal utility to check for open service ports.
  * app_ping_tool: Manual diagnostic tool for testing specific node latency.
  * app_wol_trigger: Wake-on-LAN utility for powering on remote machines.
  * app_traceroute: Path analysis tool to find network bottlenecks.

5. AUTOMATION & SCANNING (Discovery)
  * proc_network_discovery: The background engine that finds new IP addresses.
  * grid_discovery_results: Review list for newly found "Unknown" devices.
  * form_discovery_rules: Settings for IP ranges and scan frequency.

6. LOGS & ANALYTICS (Data)
  * grid_network_log: Detailed raw data view of every ping and check.
  * chart_uptime_stats: Visual reports on long-term availability.
  * chart_latency_trends: Analytics for network performance over time.
  * chart_telemetry: The dedicated blank app we built for the inline form chart.

7. SYSTEM & SECURITY (Admin)
  * form_settings: Global system configuration and API keys.
  * grid_sec_users: User management for platform access.
  * form_sec_groups: Permission and role-based access control.
  * app_login: The secure entry point for the platform.
  * grid_audit_trail: Complete history of who accessed what and when.


### LanMan Project....
* **Database:** [Download Project ](COMING)

### LanMan Database Mysql
* **Database:** [Open Database ](./lanmap_db.sql)

### LanMan Scripts
* **Network Scanner: Scans Network Devices, Updates Database** [Open Scan Script ](./lanmap.py)
* **Database Cleaner: Cleans Logs** [Open Clean Script ](./lanmap_clean.py)

## LanMan Setup Guide
* **Setup-Readme: [ Open Setup Guide ](./setup-readme.md)
