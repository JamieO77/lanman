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
  

## 🔧 Full System Explanation

**1. The Universal Cyber Viewer**
Normally, when you click a file on the internet, it downloads to your Downloads folder. LANMAN stops this. It fetches the file on the server, figures out what type it is, and uses the right engine to paint a picture of it on your screen.

**2. Security & Redundancy**
LANMAN treats all data as top-secret.
* *The Backup Protocol:* Before you change a file, LANMAN makes a safe copy, stamps it with the exact time, and puts it in a secure `/bkp/` folder. If you make a mistake, you can instantly go back.
* *Integrity Checks:* Before opening a file, the system knocks on the door to see if the file is actually there. If it is missing, you get a clear red alert instead of a broken webpage.

**3. Optimized User Experience (UX)**
* *Toggle-View:* One button flips the screen from "Formatted View" (for reading) to "Edit Mode" (for modifying).
* *Smart Sizing:* The portal looks at your monitor size (from small laptops to massive 4K screens) and perfectly centers the document so it is always easy to read.

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



