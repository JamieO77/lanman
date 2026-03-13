🛰️ LANMAN: Infrastructure Command & Intelligence

LANMAN is a centralized, high-security command station for network infrastructure and asset management. Built on a Senior-level Tech Stack (PHP 8.1+, MySQL 8, Scriptcase 9+), it acts as a secure "glass pane" for your entire network. It allows you to monitor, diagnose, and manage remote nodes—from IP cameras to Linux servers—without leaving your browser or downloading sensitive data to your local machine.

🚀 Core Capabilities
* *Unified Asset Intelligence: A high-performance MySQL 8/MariaDB backend acts as a "Single Source of Truth" for every hardware node, IP address, and credential on your network.
* *Zero-Footprint Management: Perform deep-dive diagnostics (SSH, Port Scanning, PTZ Control) through a secure web window. No local tools or software installations are required.
* *Real-Time Telemetry (Heartbeat): Automated Python and PHP workers perform continuous health checks, capturing latency and uptime data every minute to visualize network stability.
* *Multi-Protocol Decoders: Built-in engines to handle diverse data streams, including ONVIF for cameras, SSH for servers, and RTSP/MJPEG for live video.

<img width="1967" height="1241" alt="image" src="https://github.com/user-attachments/assets/d73704f1-bce4-4911-b25e-b316c94de435" />

🛠️ Integrated Toolset
1. Surveillance Command (Cam Viewer)
* *What it does: Provides a low-latency window into MJPEG/RTSP streams with integrated PTZ (Pan-Tilt-Zoom) controls.
* *Example: Use the directional overlay to move an ONVIF camera and view its telemetry stats (Uptime/Latency) on the same screen.

2. Network Diagnostic Suite
* *What it does: A collection of hardware-level utilities including Port Scanners, Ping Tools, and Traceroute.
* *Example: If a node goes offline, use the Port Scanner to see if services like HTTP (80) or RTSP (554) are still responding before leaving your desk.

3. Remote Terminal (Web-SSH)
* *What it does: A professional, browser-based console for direct Linux/Windows server administration.
* *Example: Restart a service or update a config file on a remote server without needing a local SSH client like Putty.

4. Discovery Engine
* *What it does: An automated "sniffer" that identifies new devices appearing on the network.
* *Example: It scans a defined IP range, finds a new camera, and allows you to "Import" it into the Asset Manager with one click.

5. Secure Document & Media Engine
* *What it does: Securely renders PDFs, Word docs, and Media logs using server-side processing (PDF.js / Mammoth.js).
* *Example: Review a network topology PDF or a recorded security clip (.mp4) instantly within the portal’s sandbox.


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
* 
## System Deployment Guide

This section outlines the deployment procedures for the Lanman network discovery platform. The architecture is divided into the frontend web interface (Scriptcase/PHP) and the backend discovery engine (Python).

### 1. Database Initialization
The platform requires the relational database to be provisioned before the web application or scanning scripts are executed. A structural SQL dump is provided in the repository.

* **Access Database Manager:** Open phpMyAdmin (available at `http://localhost:8084` in the Docker stack, or typically `http://localhost/phpmyadmin` in WAMP).
* **Create Schema:** Create a new database named `lanman_db` using the `utf8mb4_general_ci` collation.
* **Import Structure:** Navigate to the **Import** tab, upload the included `.sql` file, and execute the import to build the required tables.

### 2. Web Application Deployment

#### Method A: Docker Stack (Recommended)
This method utilizes the pre-configured `docker_lanman_stack.yml` to isolate dependencies.

1.  **Start the Stack:** Execute `docker compose -f docker_lanman_stack.yml up -d` in the host terminal.
2.  **Verify Services:** Ensure the Apache, MySQL, and phpMyAdmin containers report a healthy status.
3.  **Application Access:** Navigate to `http://localhost:8089`.
4.  **Scriptcase Configuration:** Upon first launch, access the Scriptcase production environment connection settings. Point the database connection to host `127.0.0.1` (or the internal Docker DNS name `mysql`), utilizing the credentials defined in your environment variables.

#### Method B: WAMP / Local Apache Server
This method deploys the application directly onto the host operating system.

1.  **Environment Preparation:** Ensure your WAMP server is running **PHP 8.2**. 
2.  **Enable Extensions:** Open your `php.ini` file and verify the following extensions are uncommented and active: `extension=gd`, `extension=pdo_mysql`, `extension=mysqli`, `extension=zip`, `extension=mbstring`. Restart Apache.
3.  **Deploy Files:** Extract the compiled Scriptcase project files into your WAMP document root (e.g., `C:\wamp64\www\lanman`).
4.  **Application Access:** Navigate to `http://localhost/lanman`. Configure the database connection parameters to match your local MySQL instance.

### 3. Discovery Engine Deployment (Python Scripts)
The backend engine requires raw network socket access to transmit ARP and ICMP packets. It consists of `scan.py` (network mapping) and `cleanup.py` (database sanitization).

#### Prerequisites (All OS)
1.  Install Python 3.11 or higher.
2.  Install required libraries: `pip install mysql-connector-python scapy python-nmap`.

#### Linux Execution
1.  **Install System Dependencies:** Execute `sudo apt-get update && sudo apt-get install nmap libpcap-dev`.
2.  **Configure Execution Permissions:** `chmod +x scan.py cleanup.py`.
3.  **Schedule via Cron:** Open the root crontab (`sudo crontab -e`). Scapy requires `root` privileges to craft raw packets.
4.  **Append Schedules:** Add the following lines to run the scan hourly and the cleanup daily at midnight:
    ```text
    0 * * * * /usr/bin/python3 /path/to/lanman/scripts/scan.py >> /var/log/lanman_scan.log 2>&1
    0 0 * * * /usr/bin/python3 /path/to/lanman/scripts/cleanup.py >> /var/log/lanman_clean.log 2>&1
    ```

#### Windows Execution
1.  **Install System Dependencies:** Download and install the official [Nmap executable for Windows](https://nmap.org/download.html). Ensure **Npcap** is selected during the installation process, as it is strictly required for Scapy to interface with Windows network adapters.
2.  **Open Task Scheduler:** Launch the Windows Task Scheduler (`taskschd.msc`).
3.  **Create Scanner Task:** * **General:** Name it "Lanman Scanner". Check **"Run with highest privileges"** (Required for Npcap).
    * **Triggers:** New -> Daily -> Repeat task every 1 hour.
    * **Actions:** New -> Start a program. Program/script: `python.exe`. Add arguments: `C:\path\to\lanman\scripts\scan.py`.
4.  **Create Cleanup Task:** Repeat Step 3 for `cleanup.py`, setting the trigger to run once daily at 12:00 AM.

