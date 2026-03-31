# 🛰️ Network_Discovery | System Documentation

## DEVELOPED on WINDOWS, RUNNING on LINUX - Works on Both!

## 1. System Overview
The **Network_Discovery** portal is a high-performance, multi-threaded asset management and reconnaissance suite. It is designed to map local area networks (LANs), identify host telemetry, and promote discovered nodes into a managed asset database.

### Core Tech Stack
* **Backend:** PHP 8.2 (ScriptCase 9+ Environment)
* **Database:** MySQL 8 / MariaDB (Strict `lower_case_naming` convention)
* **Engine:** Nmap (Unprivileged Mode) + PHP Native Sockets
* **Frontend:** Tailwind CSS 4, D3.js (Topology), Chart.js (Telemetry)


### Deployment
* ** Deploy Lanmnan on a Desktop or Laptop for mobile scanning, install Apache, Php8.2 (plus requirements), Mysql Database, or [UniServer](https://www.uniformserver.com/) (don't forget to download the php.82 [addon zip](https://www.uniformserver.com/ZeroXI_documentation/php.html) also), setup database, setup requirements, copy LANMAN zip into www folder, unzip, setup portal, adjust your network settings, and start scanning!
---

## 2. Scanning Methodologies
The portal utilizes three distinct scan modes to balance speed against depth of intelligence.

### A. Standard Sweep (`mode 0`)
* **Primary Tool:** OS Native Ping (ICMP).
* **Function:** Rapid availability check.
* **Behavior:** If ICMP is blocked, the host is marked offline.

### B. Full Sweep (`mode 1`)
* **Primary Tool:** ICMP Ping.
* **Secondary Tool (Nmap):** If Ping fails, executes `nmap -sT -p 80,443,445 --unprivileged`.
* **Logic:** Detects "Stealth" hosts that ignore ICMP but have common web/SMB ports open.

### C. Deep Ports Sweep (`mode 2`)
* **Primary Tool:** Nmap `--top-ports 20`.
* **Secondary Tool:** Native PHP `fsockopen` fallback for common administrative ports.
* **Intelligence:** Identifies running services (SSH, HTTP, RDP, PVE, etc.) and populates the service matrix.

---

## 3. The Multi-Threading Engine
The scanner uses a **Concurrency Throttle** to prevent CPU exhaustion and network congestion.

1.  **Queue Construction:** Decomposes comma-separated CIDR ranges (e.g., `192.168.1.0/24, 10.0.0.0/24`) into a flat array.
2.  **Thread Allocation:** Spawns asynchronous `fetch` requests in the browser, matching the `discovery_max_threads` value.
3.  **Real-time Telemetry:** * **Rolling Average:** Calculates latency trends via Chart.js sparklines.
    * **Dynamic ETA:** Calculates remaining time based on current processing velocity (IPs/sec).

---

## 4. Asset Classification & Promotion
Discovered nodes are processed through a regex-based classification engine to determine their role.

* **Identification:** Matches Hostnames and MAC Vendors against patterns (e.g., `srv` → **Server**, `sw` → **Switch**, `pve` → **Proxmox**).
* **Promotion:** Allows "Unmanaged" nodes to be promoted to the `network_assets` table with custom names and notes.
* **Enrichment:** Once promoted, assets transition from a "Discovery" state to a "Monitored" state with persistent historical tracking.

---

## 5. Environment Setup

### Windows Requirements
* **Nmap:** Must be installed [Download NMAP](https://nmap.org/download#windows) and reachable.
* **Permissions:** The Web Server user (`IUSR` or `NetworkService`) must have "Read & Execute" permissions on the Nmap directory.
* **Path:** Configured in `network_options` (e.g., `C:\Program Files (x86)\Nmap\nmap.exe`).
* ** Speedtest-cli must be installed for speed tests to work, will work without

### Linux/Ubuntu Requirements
Install core dependencies via CLI:
```cmd
sudo apt update && sudo apt install -y nmap arp-scan iputils-ping php8.2-cli php8.2-mysql
sudo setcap cap_net_raw,cap_net_admin,cap_net_bind_service+ek $(which nmap)```

