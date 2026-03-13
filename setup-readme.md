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
