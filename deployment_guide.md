# 📂 Local Deployment Guide: Uniform Server (UniServerZ)

This guide outlines the rapid deployment of **LanMan V.3** on a Windows-based architecture using **Uniform Server (UniServerZ)**. This setup is highly recommended for mobile network audits, "War-Driving," or localized subnet reconnaissance where a zero-install WAMP stack is required.

---


### LOCAL HOSTING - UNISERVER/WAMP/OTHER

### 1. Core Prerequisites & Download
Before initiating the deployment, ensure you have the following components:

* **Uniform Server (UniServerZ):** [Download Latest UniServerZ](https://www.uniformserver.com/) (Select Zero-Install PHP 8.2 compatible version).
* **LanMan Project Archive:** [Download .zip](https://www.dropbox.com/scl/fi/qvszzt0huqrzok46k13pw/LanMan_v3.zip?rlkey=wy302249z4jugspmpuyr0ov82&st=6xtw3qye&dl=0)
* **Python 3.11+:** Must be installed on the host Windows machine to execute the background discovery daemons.
* **NMAP [Download NMAP](https://nmap.org/download#windows)
---

### 2. File System Initialization
1.  **Extract UniServerZ:** Decompress the Uniform Server archive to your desired root directory (e.g., `C:\UniServerZ\` or a high-speed USB drive).
2.  **Deploy LanMan Source:** * Navigate to the `/www/` directory inside your UniServerZ folder.
    * Create a new folder named `lanman`.
    * Extract the contents of the **LanMan Project Archive** into `C:\UniServerZ\www\lanman\`.
3.  **Root Access Check:** Ensure the `index.php` of the dashboard is located at `.../www/lanman/index.php`.

---

### 3. Database Ingestion (MySQL/MariaDB)
1.  Launch `UniController.exe` and start both the **Apache** and **MySQL** services.
2.  Open **phpMyAdmin** (usually at `localhost/phpmyadmin`).
3.  Create a new database named `lanman_db` using `utf8mb4_general_ci` collation.
4.  Select the `lanman_db` and use the **Import** tab to upload the provided `lanman_db.sql` file.
5.  **Credential Sync:** Update your Scriptcase connection settings or the global config file to match your UniServerZ MySQL credentials (default is usually `root` with no password).

---

### 4. Background Daemon Configuration (Python)
The discovery engine requires the Python scripts to be linked to your local environment or use the CRON jobs (see No5 and portal help files), DO NOT USE THEM BOTH!

For Python scripts install: 
```cmd
sudo apt update && sudo apt install -y nmap python3 python3-pip python3-venv php8.2-cli php8.2-mysql php8.2-curl php8.2-gd php8.2-xml php8.2-mbstring arp-scan iputils-ping speedtest-cli
```

Download Python scripts:
1.  Copy `lanmap.py` and `lanmap_clean.py` to a dedicated scripts folder (e.g., `C:\UniServerZ\scripts\`).
2.  Open `lanmap.py` in an editor and update the database connection string:
    ```python
    db_config = {
        'host': '127.0.0.1',
        'user': 'root',
        'password': '',
        'database': 'lanman_db'
    }
    ```
3.  Install required libraries via Terminal:
    `pip install scapy mysql-connector-python`

---

### 5. Automation Setup (Windows Task Scheduler)
Since Uniform Server does not utilize native Linux Crontab, use **Windows Task Scheduler** to mimic the Cron Lifecycle:

| Task Name | Action | Trigger |
| :--- | :--- | :--- |
| **LanMan_Automation** | `php.exe C:\UniServerZ\www\cron_orchestator/index.php` | Repeat every 5-30 Minutes |
or
| **LanMan_Automation** | Python 3.11 | `C:\UniServerZ\scripts\lanmap_orchestator.py` | Every 5-30 Minutes |

**Pro Tip:** Ensure "Run with highest privileges" is checked in the task settings to allow the Python engine access to raw network sockets for ARP scanning.

---

### 🚀 Accessing the Dashboard
Once the services are active and the tasks are scheduled, access your local command station at:
**`http://localhost/lanman/`**

* **Default Username:** `admin_access`
* **Default Password:** `admin_access`
