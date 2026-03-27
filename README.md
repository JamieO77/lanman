# 🛰️ LanMan V.3: Infrastructure Command & Intelligence

### DOWNLOAD LINKS AT BOTTOM!

LANMAN is a centralized, high-security command station designed for comprehensive network infrastructure and asset management. Engineered on a highly optimized web stack (PHP 8.2, MySQL 8.0, Scriptcase 9+), it functions as a secure, single-pane-of-glass interface for your entire local area network. It empowers administrators to monitor, diagnose, and actively manage remote nodes—ranging from IP surveillance cameras to headless Linux servers—directly from the browser, entirely eliminating the need for localized management clients. LanMan is a centralized, high-security command station for network infrastructure and asset management htat you can deploy locally.

### 🚀 Core Capabilities

* **Autonomous Network Reconnaissance:** Operates a headless Python 3.11 discovery engine (`scan.py` and `cleanup.py`) utilizing raw ARP and ICMP sockets to continuously map the physical data-link layer. It automatically detects rogue devices, tracks dynamic DHCP allocations, and dynamically purges stale host records.
* **Unified Asset Intelligence:** A high-performance MySQL 8 backend serves as the immutable "Single Source of Truth." It securely warehouses hardware MAC addresses, IP allocation histories, vendor metadata, and encrypted device credentials utilizing strict relational database structures.
* **Zero-Footprint Administration:** Execute deep-dive network diagnostics directly through the web interface. Capabilities include an embedded SSH terminal for secure server administration, raw TCP/UDP port scanning, and active service enumeration without deploying local software agents.
* **Surveillance & Media Integration:** Natively decodes and manages diverse multimedia streams. Features built-in ONVIF protocol support for automated IP camera discovery, active web-based PTZ (Pan-Tilt-Zoom) mechanical control, and localized RTSP/MJPEG video stream proxying.
* **Real-Time Telemetry & Heartbeat:** Automated Python and PHP workers execute continuous ICMP health checks across all registered infrastructure nodes. The platform captures granular latency metrics and uptime persistence, allowing administrators to immediately identify network degradation or hardware failures.

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

# AND SO MUCH MORE....


## 🚀 Portal Screenshots

### 🖥️ Network Command Dashboard (LanMan v3)
<img width="2288" height="1356" alt="image" src="https://github.com/user-attachments/assets/f7242af5-350a-423f-9066-502f948185cf" />

This is the primary operations hub, providing a real-time, single-pane-of-glass overview of your entire infrastructure's health and telemetry. 

**Key dashboard components include:**
* **Live Telemetry:** Real-time bandwidth gauges (Download/Upload) and continuous external DNS latency tracking against critical endpoints (e.g., 8.8.8.8).
* **Asset Health Visualization:** Visual charts detailing global network availability (Online/Offline ratios) and isolating the slowest responding hardware assets on the subnet.
* **Event & Bottleneck Tracking:** A live data grid logging precise network events (such as latency spikes and manual daemon restarts) alongside a dedicated panel for immediate bottleneck alerts.
* **Service Integrity Matrix:** Continuous polling of critical external web services and internal daemons, instantly highlighting offline environments.
* **Quick-Action Integration:** Rapid execution toggles for network discovery protocols, automated cleanup routines, and webhook notification testing (Telegram, Slack, Email).


### 🗺️ Live Network Topology Map
<img width="2315" height="1360" alt="image" src="https://github.com/user-attachments/assets/b5c0fb2a-206d-43d5-8418-1f72ae7c3861" />

This module provides an interactive, visual representation of the physical and logical network infrastructure, delivering immediate spatial awareness of all connected assets.

**Key mapping components include:**
* **Dynamic Node Visualization:** Graphical mapping of core assets utilizing distinct iconography (routers, access points, IP cameras, servers) to display physical relationships and network hierarchy.
* **Rogue Device Identification:** Visually isolates unidentified or untagged hardware (highlighted with purple markers), allowing administrators to quickly spot and investigate unauthorized MAC addresses on the subnet.
* **Interactive Asset Sidebar:** A collapsible control panel categorizing Core Assets, Active Services, and Unidentified Nodes. It includes direct action buttons next to each IP for immediate administration, wake-on-LAN execution, or deeper node inspection.
* **Canvas Controls & Search:** Integrated pan and zoom controls alongside a global node-search bar to rapidly locate specific hardware within dense or complex subnet environments.


### 📈 Network Analysis & Live Telemetry
<img width="1902" height="1343" alt="image" src="https://github.com/user-attachments/assets/e3f554fd-f48c-4323-9dac-4d2adc0e0db5" />

This module delivers granular, real-time analytics of network performance, device categorization, and historical event logging to facilitate deep-dive infrastructure troubleshooting.

**Key analytical components include:**
* **Global Telemetry Header:** Top-level metrics consolidating total node inventory, active services, current bandwidth utilization, and pending discovery alerts.
* **Real-Time Latency Monitoring:** An interactive, live-streaming graph tracking ICMP ping latency against selectable external targets (e.g., Google DNS) to visualize transient ISP instability or internal congestion spikes.
* **Event Logging & Bottleneck Identification:** Dedicated data matrices capturing critical latency events, service state transitions (Online/Offline), and sustained node performance degradation over time.
* **Infrastructure Density Visualization:** A categorized bar chart and ecosystem matrix breaking down the hardware composition of the network (e.g., servers, switches, cameras, IoT devices) to assist in capacity planning and subnet segregation.
* **Targeted Hardware Probing:** Isolated latency trackers for critical infrastructure components, such as the primary gateway and core switches, alongside a custom IP targeting tool for ad-hoc node diagnostics.


### 🗄️ Log Matrix & Historical Telemetry
<img width="1802" height="1041" alt="image" src="https://github.com/user-attachments/assets/79d6508f-93cc-4732-a80a-fc29a4cce2fc" />

This module serves as the centralized logging repository, aggregating system events, hardware state changes, and performance anomalies into a structured, chronologic interface for auditing and post-incident review.

**Key logging components include:**
* **Global Event Counters:** Top-level statistical cards quantifying total platform activities, active warnings, critical exceptions, and a lifetime historical tally of offline node events.
* **System Activity Ledger:** A chronological feed capturing general platform interactions, automated script executions, and administrative events.
* **Outages & Spikes Tracking:** An isolated event stream dedicated strictly to critical failures. It logs the exact timestamps when nodes drop offline (0ms response) or exceed defined latency thresholds (e.g., >100ms), providing a precise timeline of infrastructure degradation.
* **Bandwidth Audits:** A dedicated historical ledger for automated or manual speed test executions, tracking long-term ISP performance and throughput consistency.
* **Log State Management:** Integrated controls to force-pull the latest database telemetry or purge the current UI view to isolate specific troubleshooting timeframes.


### 👁️ Net Vision Pro (Asset Matrix)* Network Overviews:
<img width="1768" height="1027" alt="image" src="https://github.com/user-attachments/assets/e7908385-a98b-484a-8a1c-bc8dd68a9b64" />

This module serves as a highly dense, dynamic monitoring matrix, delivering an at-a-glance status overview of all categorized network endpoints within the infrastructure.

**Key monitoring components include:**
* **Real-Time Status Matrix:** A grid-based visualization of hardware assets featuring immediate, color-coded state indicators (Online/Green, Offline/Red, Standby/Grey). Each asset card embeds a dedicated sparkline chart designed to track historical latency trends per node.
* **Dynamic Visibility Filtering:** A comprehensive right-hand control panel utilizing boolean toggles. This allows administrators to instantly isolate specific hardware categories (e.g., Firewalls, Access Points, IoT Devices) or individual nodes, significantly reducing visual noise during targeted troubleshooting.
* **Multi-Modal UI Layouts:** Top-level navigation toggles enabling rapid pivoting of the data presentation between standard Lists, categorized Groups, the active Matrix view, and a Neural logical layout.
* **Universal Asset Search:** A rapid-filtering search bar integrated directly into the header, allowing for instant location of specific hardware by hostname or IP address across massive, multi-subnet deployments.


### 📹 Camera Command (Surveillance Grid)
<img width="1947" height="647" alt="image" src="https://github.com/user-attachments/assets/94141bdc-2b0c-49f7-9542-5d7aef63aac9" />

This module acts like a universal remote control for all your security cameras. It gathers your video feeds and camera controls onto one simple screen.

**Key features include:**
* **Live Video Feeds:** Watch real-time video (MJPEG streams) straight from the camera to your web browser. *Example: Viewing your driveway camera instantly without opening a separate app.*
* **PTZ Directional Controls:** Use the on-screen arrow pad to physically move the camera lens. *Example: Clicking the right arrow makes the physical camera spin right to look at a different door.*
* **Connection Speed (Latency):** Every camera shows a millisecond (ms) number so you know if the network connection is healthy. *Example: The Tapo camera shows 98ms, meaning it has a stable, fast connection to the router.*
* **Auto-Cycle:** A hands-free mode that automatically switches the screen between different cameras, exactly like a security guard watching a rotating monitor.
  
### 🧰 Integrated Utility Toolkit (Tools Menu)
<img width="210" height="1157" alt="image" src="https://github.com/user-attachments/assets/3c9833da-7998-4513-af63-7828cf568546" />

This menu acts as your digital Swiss Army knife. It contains specialized mini-applications for writing code, testing network connections, and managing remote servers without ever leaving the dashboard.

**Core Command Nodes**
* **Docker / Linux / Windows Nexus:** Built-in dictionaries of the most important computer commands. *Example: Looking up the exact phrase needed to restart a server or find a hidden file without having to search the internet.*
* **LLM Nexus:** A comparison guide and instruction manual for different artificial intelligence models. *Example: Reading about which AI is smartest for coding, and copying the exact command to download and run it securely on your own server.*

**Dev (Developer Utilities)**
* **Base Plate Gen:** Automatically builds starter code templates so you do not have to type from scratch.
* **Base 64 Transcoder:** Translates normal text into scrambled computer code and back again. *Example: Hiding a secret key in a format that only machines can read.*
* **Chroma Sync:** A tool to perfectly match and pick visual colors for web design.
* **Domain Recon & URL Codec:** Breaks down long web links to see exactly where they lead and who owns them.
* **Regex Architect:** A builder that helps you write precise search patterns to find specific errors hidden in massive log files.
* **SQL Architect & Insert Factory:** Generates the exact database commands required to save, edit, or read information in your MySQL tables.

**Network (Diagnostic Radar)**
* **Recon Node & LAN Scanner:** Acts like a submarine radar, sending out signals to find every single device plugged into your building.
* **Docker Composer:** A builder for assembling and launching your container stacks.
* **DNS Propagator:** Checks if a newly purchased website name has updated across the global internet yet.
* **Security Inspector:** Scans a computer to see if it left any digital doors (ports) unlocked.
* **Latency Probe & Service Probe:** Tests exactly how fast a device replies to a knock on its door. *Example: Checking if the office printer is awake and responding.*
* **IPv4 Subnet Calc:** A network calculator that helps you divide a massive network into smaller, secure pieces.
* **Infra Mapper & Identify:** Draws the physical connections between your routers and switches to show how data travels.
  
* AND SO MUCH MORE!!!!

## ⚙️ Automation & Cron Lifecycle

To maintain a real-time "Zero-Footprint" administration environment, LanMan utilizes a multi-tiered automation strategy. These background workers ensure the MySQL discovery engine and log buffers remain optimized and accurate without manual intervention.

### 1. Persistent Network Discovery (`lanmap.py`)
This is the primary reconnaissance engine. It is designed to run frequently to catch new DHCP leases, track latency spikes, and identify rogue devices.
* **Frequency:** Recommended every 5–15 minutes.
* **Function:** Executes raw ARP/ICMP sweeps, resolves hardware OUI (Vendor) data, and updates the `network_assets` table with fresh telemetry and status timestamps.

### 2. Autonomous State Sanitization (`lanmap_clean.py`)
This script acts as the system's "Garbage Collector," ensuring the dashboard and database remain high-performance.
* **Frequency:** Recommended every 1–2 hours.
* **Function:** Purges host records that have failed to respond to discovery sweeps over a defined threshold and truncates historical telemetry logs to prevent storage bloat.

### 3. Service & Health Polling (PHP/Scriptcase Workers)
While the Python engine handles the Data-Link layer, the internal PHP workers manage high-level Service Integrity (Web, SQL, SSH availability).
* **Frequency:** Triggered via system flags or scheduled intervals.
* **Function:** Updates the "Service Integrity Matrix" and dispatches high-priority webhooks (Telegram/Slack/Email) the moment a critical node state transitions to **OFFLINE**.

---

### 🛠️ Example Crontab Configuration
For a standard production deployment, add the following to your crontab (`crontab -e`) to ensure maximum infrastructure visibility:

```bash
# LanMan V.3 Automation Suite
# -----------------------------------------------------------
# 1. Discover new assets and update latency every 5 mins
*/5 * * * * /usr/bin/python3 /var/www/html/scripts/lanmap.py >> /var/log/lanman_scan.log 2>&1

# 2. Cleanup stale records and truncate logs every hour at minute 0
0 * * * * /usr/bin/python3 /var/www/html/scripts/lanmap_clean.py >> /var/log/lanman_clean.log 2>&1

# 3. Optional: Trigger Service Integrity Matrix (Every minute)
* * * * * /usr/bin/php /var/www/html/index.php --action=health_check > /dev/null 2>&1
```

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

### INDEX PAGE REPLACEMENT
* **Access the _lib/libraries/grp/lib folder, copy index.php, and replace with the one in the root folder
* **Or Download if from here and replace:  [Open Index Page Replacement ](./index.php)

### LanMan Project....
* **FULL PROJECT:** [Download Project ] (.[https://www.dropbox.com/scl/fi/5waojaq1fdpbk8c3kwsma/LanMan_v3_5_20260326141335000000.zip?rlkey=ixfiefz5xcjhnn2o8ld4cjfm4&st=tt3oja65&dl=0](https://www.dropbox.com/scl/fi/0kos3rqqjn4odr4b5qm5r/LanMan_v3_5_20260326142601000000.zip?rlkey=vy6jes5y12gq4fqmtn3exylzi&st=f77m3wks&dl=0))

* Username: admin_access
* Password: admin_access

### LanMan Database Mysql
* **Database:** [Open Database ](./lanmap_db.sql)

### LanMan Scripts
* **Network Scanner: Scans Network Devices, Updates Database** [Open Scan Script ](./lanmap.py)
* **Database Cleaner: Cleans Logs** [Open Clean Script ](./lanmap_clean.py)

## LanMan Setup Guide
* **Setup-Readme: [ Open Setup Guide ](./setup-readme.md)
