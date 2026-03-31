# LanMan Dedicated Worker Node Setup

Run the system health check available in the main menu under Portal.
This guide turns a fresh Raspberry Pi or Ubuntu Server into a dedicated background worker for the LanMan portal. 

Think of this server as an isolated factory. 
We are going to install the required network tools, create a safe sandbox for Python, and set up the automatic alarm clocks (Cron jobs) so your scripts run forever without overloading the host system.

## Step 1: Install the System Tools
Before you can use the scripts so that Python can scan your network, the operating system first needs the raw networking tools to ping, trace, and scan.

Log into your server via SSH, or locally and run this command in terminal to update the system and install the required tools:

sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv nmap traceroute snmp speedtext-cli

## Step 2: Build the Python Sandbox
Modern Linux systems lock the main Python installer to prevent you from breaking core system files. We will build a "Virtual Environment" (a safe, isolated folder) just for these scripts.

Run these commands one by one. (Note: Replace jamie with your actual Linux username if it is different, such as pi or ubuntu):

mkdir -p /home/username/lanman_worker
cd /home/username/lanman_worker
python3 -m venv venv
source venv/bin/activate
  
You will know this worked when your terminal prompt changes to start with (venv).

## Step 3: Install the Python Libraries
While inside the active sandbox, install the exact parts the scripts need to talk to MySQL, connect to switches via SSH, and check websites.

pip install mysql-connector-python requests paramiko netmiko

## Step 4: Add Your Scripts
You need to place your two main scripts inside the /home/username/lanman_worker/ folder.

lanman.py - The 1-minute network discovery and health monitor.
lanman_clean.py - The daily database log cleanup tool.

You can download these from the repository, or create them directly using:

## CODE:
nano lanman.py
see repo file, download file, upload or copy and paste as you please...

nano lanman_clean.py
see repofile , download file, upload or copy and paste as you please...

                                
## Step 5: Set the Alarm Clocks (Cron Jobs)
Cron is the brain that tells your scripts exactly when to wake up. We must use the absolute path to your sandbox so Cron knows to use the isolated tools we just installed.

Open the Cron editor:

crontab -e
  
Scroll to the very bottom of the file and paste these two exact lines. (Again, ensure /home/jamie/ matches your actual Linux user directory):

# Run the scanner every 1 minute
* * * * * /home/username/lanman_worker/venv/bin/python /home/username/lanman_worker/lanman.py >> /home/username/lanman_worker/scanner.log 2>&1

# Run the cleanup at 2:00 AM every day
0 2 * * * /home/username/lanman_worker/venv/bin/python /home/username/lanman_worker/lanman_clean.py >> /home/username/lanman_worker/clean.log 2>&1

Save and exit. Your dedicated worker node is now fully operational and will immediately begin syncing data to your LanMan portal.

** Be sure to change username to your own username!
