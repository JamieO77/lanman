CREATE DATABASE `lanman` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `lanman`;

DROP TABLE IF EXISTS `asset_documents`;
CREATE TABLE `asset_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT NULL COMMENT 'manual, invoice, config_backup, license',
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `file_size_kb` int(11) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `asset_document_links`;
CREATE TABLE `asset_document_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  CONSTRAINT `asset_document_links_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `asset_documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chats`;
CREATE TABLE `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usr_login` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT 'new session',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_chat_user` (`usr_login`),
  CONSTRAINT `fk_chat_user` FOREIGN KEY (`usr_login`) REFERENCES `sec_users` (`login`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chat_api_logs`;
CREATE TABLE `chat_api_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `engine` varchar(50) NOT NULL,
  `status` enum('success','error') DEFAULT 'success',
  `error_message` text,
  `latency_ms` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_chat_logs` (`chat_id`),
  CONSTRAINT `fk_chat_logs` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chat_files`;
CREATE TABLE `chat_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT 'document',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_chat_files` (`chat_id`),
  CONSTRAINT `fk_chat_files` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE `chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `role` enum('user','assistant') NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_chat_messages` (`chat_id`),
  CONSTRAINT `fk_chat_messages` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chat_prompts`;
CREATE TABLE `chat_prompts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `prompt_text` text,
  `icon` varchar(50) DEFAULT 'fa-terminal',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `chat_settings`;
CREATE TABLE `chat_settings` (
  `chat_id` int(11) NOT NULL,
  `engine` varchar(50) DEFAULT 'gemini',
  `output_length` varchar(50) DEFAULT 'medium',
  `output_style` varchar(50) DEFAULT 'technical',
  `memory_active` tinyint(1) DEFAULT '1',
  `temperature` decimal(3,2) DEFAULT '0.70' COMMENT 'Creativity scale 0.0 to 1.0',
  `system_instruction` text COMMENT 'The hidden base prompt for this specific chat',
  `top_p` decimal(3,2) DEFAULT '1.00' COMMENT 'Nucleus sampling factor',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  CONSTRAINT `fk_chat_settings` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SET NAMES utf8mb4;

DROP TABLE IF EXISTS `monitor_logs`;
CREATE TABLE `monitor_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `latency_ms` decimal(10,2) DEFAULT NULL,
  `ssl_expiry_date` date DEFAULT NULL,
  `http_status` int(11) DEFAULT NULL,
  `status` enum('online','offline') DEFAULT 'online',
  `checked_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ttfb_ms` decimal(10,2) DEFAULT '0.00',
  `load_ms` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `fk_node_log` (`node_id`),
  CONSTRAINT `fk_node_log` FOREIGN KEY (`node_id`) REFERENCES `monitor_nodes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `monitor_nodes`;
CREATE TABLE `monitor_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_name` varchar(100) NOT NULL,
  `target_address` varchar(255) NOT NULL,
  `node_type` enum('server','website','gateway','iot','asset','discovery','service') DEFAULT 'server',
  `check_interval_mins` int(11) DEFAULT '5',
  `timeout_seconds` int(11) DEFAULT '5',
  `monitor_ping` tinyint(1) DEFAULT '1',
  `monitor_latency` tinyint(1) DEFAULT '1',
  `monitor_ssl` tinyint(1) DEFAULT '0',
  `monitor_http_status` tinyint(1) DEFAULT '0',
  `expected_http_code` int(11) DEFAULT '200',
  `notify_email` tinyint(1) DEFAULT '0',
  `notify_slack` tinyint(1) DEFAULT '0',
  `notify_telegram` tinyint(1) DEFAULT '0',
  `fail_count_threshold` int(11) DEFAULT '3',
  `current_status` enum('online','offline','degraded','maintenance') DEFAULT 'online',
  `fail_count_current` int(11) DEFAULT '0',
  `last_check_at` datetime DEFAULT NULL,
  `first_seen_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_online_at` datetime DEFAULT NULL,
  `ssl_expiry_date` date DEFAULT NULL,
  `notes` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_ai_cache`;
CREATE TABLE `network_ai_cache` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_type` varchar(50) DEFAULT 'overview',
  `summary_text` text,
  `stats_snapshot` json DEFAULT NULL,
  `generated_by` varchar(255) DEFAULT NULL COMMENT 'Links to sec_users.login',
  `generated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_alerts`;
CREATE TABLE `network_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `alert_type` varchar(50) DEFAULT NULL,
  `message` text,
  `sent_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_assets`;
CREATE TABLE `network_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_name` varchar(255) NOT NULL,
  `asset_type` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `admin_port` varchar(50) DEFAULT NULL,
  `admin_http` enum('http','https') DEFAULT NULL,
  `hostname` varchar(255) DEFAULT 'unknown',
  `mac_address` varchar(20) DEFAULT NULL,
  `vendor` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `make` varchar(100) DEFAULT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `date_purchased` date DEFAULT NULL,
  `date_end_warrenty` date DEFAULT NULL,
  `wan_ip` varchar(45) DEFAULT NULL,
  `dns_primary` varchar(45) DEFAULT NULL,
  `location_physical` varchar(255) DEFAULT NULL,
  `asset_first` int(1) DEFAULT '0',
  `asset_user` varchar(100) DEFAULT NULL,
  `asset_pass` varchar(255) DEFAULT NULL,
  `status` varchar(10) DEFAULT 'offline',
  `last_latency` int(11) DEFAULT '0',
  `last_check_at` datetime DEFAULT NULL,
  `avg_latency` decimal(10,2) DEFAULT '0.00',
  `total_uptime_minutes` int(11) DEFAULT '0',
  `total_checks` int(11) DEFAULT '0',
  `last_check` timestamp NULL DEFAULT NULL,
  `first_seen` timestamp NULL DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  `set_discover` int(1) DEFAULT '0',
  `notification_sent_at` timestamp NULL DEFAULT NULL,
  `asset_notes` text,
  `snmp_community` varchar(100) DEFAULT NULL,
  `is_snmp_gateway` tinyint(1) DEFAULT '0',
  `fail_count` int(11) DEFAULT '0',
  `hop_count` int(11) DEFAULT '0',
  `health_check_method` enum('none','snmp','paramiko','netmiko') DEFAULT 'snmp',
  `os_info` varchar(255) DEFAULT NULL,
  `connected_port` char(50) DEFAULT NULL,
  `cpu_usage` int(3) DEFAULT '0',
  `ram_usage` int(3) DEFAULT '0',
  `disk_usage` int(3) DEFAULT '0',
  `wifi` int(1) DEFAULT '0',
  `wifi_ssid` varchar(100) DEFAULT NULL,
  `wifi_signal` int(3) DEFAULT '0',
  `cam_port` int(11) DEFAULT '80',
  `cam_path` varchar(255) DEFAULT '/video.mjpg',
  `cam_user` varchar(50) DEFAULT NULL,
  `cam_pass` varchar(50) DEFAULT NULL,
  `asset_trace` tinyint(1) DEFAULT '0',
  `os_type` enum('linux','windows','iot','network_device') DEFAULT 'linux',
  `ssh_key_path` varchar(255) DEFAULT NULL,
  `admin_panel` tinyint(1) DEFAULT '0',
  `restart_command` varchar(250) DEFAULT NULL,
  `enriched` tinyint(1) DEFAULT '0',
  `camera_type` varchar(50) DEFAULT 'mjpeg',
  `auto_wake` tinyint(1) DEFAULT '0',
  `network_scan_on` tinyint(1) DEFAULT '1',
  `monitor_on` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_classification_rules`;
CREATE TABLE `network_classification_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regex_pattern` varchar(255) NOT NULL,
  `check_target` enum('vendor','hostname') DEFAULT 'vendor',
  `asset_type` varchar(50) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_connections`;
CREATE TABLE `network_connections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_asset_id` int(11) NOT NULL,
  `target_asset_id` int(11) NOT NULL,
  `port_number` varchar(50) DEFAULT NULL,
  `connection_type` varchar(50) DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `source_asset_id` (`source_asset_id`),
  KEY `target_asset_id` (`target_asset_id`),
  CONSTRAINT `network_connections_ibfk_1` FOREIGN KEY (`source_asset_id`) REFERENCES `network_assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `network_connections_ibfk_2` FOREIGN KEY (`target_asset_id`) REFERENCES `network_assets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_discovery`;
CREATE TABLE `network_discovery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `mac_address` varchar(100) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `first_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` datetime DEFAULT NULL,
  `is_ignored` tinyint(1) DEFAULT '0',
  `status` varchar(10) DEFAULT 'offline',
  `latency` decimal(10,2) DEFAULT '0.00',
  `fail_count` int(11) DEFAULT '0',
  `hop_count` int(11) DEFAULT '0',
  `avg_latency` decimal(10,2) DEFAULT '0.00',
  `total_checks` int(11) DEFAULT '0',
  `asset_trace` int(1) DEFAULT '0',
  `enriched` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_address` (`ip_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_error_log`;
CREATE TABLE `network_error_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) DEFAULT '0',
  `ip_address` varchar(45) DEFAULT NULL,
  `error_message` text,
  `error_type` varchar(50) DEFAULT 'connection',
  `error_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_health_log`;
CREATE TABLE `network_health_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `cpu_usage` int(3) DEFAULT '0',
  `ram_usage` int(3) DEFAULT '0',
  `disk_usage` int(3) DEFAULT '0',
  `check_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_log`;
CREATE TABLE `network_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) DEFAULT '0',
  `ip_address` varchar(45) NOT NULL,
  `status` varchar(20) DEFAULT 'online',
  `latency` decimal(10,2) DEFAULT '0.00',
  `log_type` varchar(20) DEFAULT 'latency_normal',
  `check_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ip_address` (`ip_address`),
  KEY `asset_id` (`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_logins`;
CREATE TABLE `network_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usr_login` varchar(250) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `parent_type` enum('asset','service') DEFAULT NULL,
  `login_label` varchar(50) DEFAULT NULL,
  `login_path` varchar(250) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `key` varchar(250) DEFAULT NULL,
  `notes` text,
  `is_snmp` tinyint(1) NOT NULL DEFAULT '0',
  `is_docker` tinyint(1) NOT NULL DEFAULT '0',
  `display_dash` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_monthly_reports`;
CREATE TABLE `network_monthly_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_month` varchar(7) NOT NULL COMMENT 'yyyy-mm format',
  `report_type` varchar(50) DEFAULT 'ssl_dns',
  `report_data` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_options`;
CREATE TABLE `network_options` (
  `id` int(11) NOT NULL,
  `enable_search_bar` tinyint(1) DEFAULT '1',
  `enable_telegram` tinyint(1) DEFAULT '0',
  `enable_email` tinyint(1) DEFAULT '0',
  `enable_discovery` tinyint(1) DEFAULT '1',
  `enable_monitoring` tinyint(1) DEFAULT '1',
  `discovery_keep_duration` int(3) DEFAULT '7' COMMENT 'days',
  `enable_enhance` int(1) DEFAULT '0',
  `enhance_repeat_min` int(10) NOT NULL DEFAULT '30' COMMENT 'minutes',
  `enable_connections` int(1) DEFAULT '0',
  `enable_clean` tinyint(1) DEFAULT '0',
  `clean_days` int(3) DEFAULT '7',
  `ping_rate_seconds` int(11) DEFAULT '300',
  `latency_threshold_ms` int(11) DEFAULT '200',
  `telegram_token` varchar(255) DEFAULT NULL,
  `telegram_chat_id` varchar(100) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `smtp_host` varchar(255) DEFAULT NULL,
  `smtp_port` int(11) DEFAULT '587',
  `smtp_user` varchar(255) DEFAULT NULL,
  `smtp_pass` varchar(255) DEFAULT NULL,
  `smtp_secure` varchar(10) DEFAULT 'tls',
  `enable_snmp` tinyint(1) DEFAULT '0',
  `default_snmp_community` varchar(100) DEFAULT 'public',
  `host_os` enum('linux','windows') DEFAULT 'linux',
  `alarm_email_count` int(11) DEFAULT '3',
  `alarm_telegram_count` int(11) DEFAULT '3',
  `alarm_email_notice` int(11) DEFAULT '1',
  `alarm_telegram_notice` int(11) DEFAULT '1',
  `connection_timeout` int(11) DEFAULT '5',
  `discovery_parallel` tinyint(1) DEFAULT '0',
  `discovery_max_threads` int(11) DEFAULT '10',
  `discovery_timeout_min` int(11) DEFAULT '3',
  `discovery_auto_throttle` tinyint(1) DEFAULT '1',
  `check_load` tinyint(1) DEFAULT '1',
  `max_load_threshold` float DEFAULT '80',
  `enable_slack` tinyint(1) DEFAULT '0',
  `slack_webhook_url` text,
  `email_notify_failure` tinyint(1) DEFAULT '1',
  `email_notify_lost` tinyint(1) DEFAULT '1',
  `email_notify_new` tinyint(1) DEFAULT '1',
  `email_notify_latency` tinyint(1) DEFAULT '1',
  `tg_notify_failure` tinyint(1) DEFAULT '1',
  `tg_notify_lost` tinyint(1) DEFAULT '1',
  `tg_notify_new` tinyint(1) DEFAULT '1',
  `tg_notify_latency` tinyint(1) DEFAULT '1',
  `slack_notify_failure` tinyint(1) DEFAULT '1',
  `slack_notify_lost` tinyint(1) DEFAULT '1',
  `slack_notify_new` tinyint(1) DEFAULT '1',
  `slack_notify_latency` tinyint(1) DEFAULT '1',
  `alarm_cpu` int(3) DEFAULT '70',
  `alarm_ram` int(3) DEFAULT '80',
  `alarm_disk` int(3) DEFAULT '90',
  `ping_target` varchar(50) DEFAULT '8.8.8.8',
  `show_latency` int(1) DEFAULT '1',
  `show_favs` int(1) DEFAULT '1',
  `show_speed_gauge` tinyint(1) DEFAULT '1',
  `db_name` varchar(150) NOT NULL DEFAULT 'lanman',
  `display_bottlneck` tinyint(1) DEFAULT '1',
  `display_availability` tinyint(1) DEFAULT '1',
  `display_slow_assets` tinyint(1) DEFAULT '1',
  `display_vendor_mix` tinyint(1) DEFAULT '1',
  `display_distro` tinyint(1) DEFAULT '1',
  `root_path` varchar(250) DEFAULT '',
  `enable_robo_llm` int(1) DEFAULT '1',
  `api_key_openai` varchar(255) DEFAULT NULL,
  `api_key_gemini` varchar(255) DEFAULT NULL,
  `url_ollama` varchar(255) DEFAULT 'http://127.0.0.1:11434',
  `ollama_default_model` varchar(100) DEFAULT 'llama3',
  `enable_ai_overview` tinyint(1) DEFAULT '0',
  `enable_pdf_report` tinyint(1) DEFAULT '0',
  `llm_default_provider` enum('gemini','ollama','openai') DEFAULT 'gemini',
  `pdf_template_style` varchar(50) DEFAULT 'modern_dark',
  `enable_ai_log_clean` tinyint(1) DEFAULT '0',
  `robo_alert` tinyint(1) DEFAULT '1',
  `robo_alert_sound` blob,
  `robo_alert_filename` text,
  `robo_alert_size` tinytext,
  `nmap_path` varchar(500) DEFAULT 'nmap',
  `scan_range` varchar(255) DEFAULT '192.168.1.0/24',
  `scan_monitor_time` int(11) DEFAULT '5' COMMENT 'minutes',
  `scan_speed_time` int(11) DEFAULT '30' COMMENT 'minutes',
  `last_run_main` datetime DEFAULT NULL,
  `last_run_tools` datetime DEFAULT NULL,
  `last_run_clean` datetime DEFAULT NULL,
  `scan_main_time` int(11) DEFAULT '1' COMMENT 'minutes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `network_options` (`id`, `enable_search_bar`, `enable_telegram`, `enable_email`, `enable_discovery`, `enable_monitoring`, `discovery_keep_duration`, `enable_enhance`, `enhance_repeat_min`, `enable_connections`, `enable_clean`, `clean_days`, `ping_rate_seconds`, `latency_threshold_ms`, `telegram_token`, `telegram_chat_id`, `email_address`, `smtp_host`, `smtp_port`, `smtp_user`, `smtp_pass`, `smtp_secure`, `enable_snmp`, `default_snmp_community`, `host_os`, `alarm_email_count`, `alarm_telegram_count`, `alarm_email_notice`, `alarm_telegram_notice`, `connection_timeout`, `discovery_parallel`, `discovery_max_threads`, `discovery_timeout_min`, `discovery_auto_throttle`, `check_load`, `max_load_threshold`, `enable_slack`, `slack_webhook_url`, `email_notify_failure`, `email_notify_lost`, `email_notify_new`, `email_notify_latency`, `tg_notify_failure`, `tg_notify_lost`, `tg_notify_new`, `tg_notify_latency`, `slack_notify_failure`, `slack_notify_lost`, `slack_notify_new`, `slack_notify_latency`, `alarm_cpu`, `alarm_ram`, `alarm_disk`, `ping_target`, `show_latency`, `show_favs`, `show_speed_gauge`, `db_name`, `display_bottlneck`, `display_availability`, `display_slow_assets`, `display_vendor_mix`, `display_distro`, `root_path`, `enable_robo_llm`, `api_key_openai`, `api_key_gemini`, `url_ollama`, `ollama_default_model`, `enable_ai_overview`, `enable_pdf_report`, `llm_default_provider`, `pdf_template_style`, `enable_ai_log_clean`, `robo_alert`, `robo_alert_sound`, `robo_alert_filename`, `robo_alert_size`, `nmap_path`, `scan_range`, `scan_monitor_time`, `scan_speed_time`, `last_run_main`, `last_run_tools`, `last_run_clean`, `scan_main_time`) VALUES
(1,	1,	0,	0,	1,	1,	14,	1,	30,	0,	1,	14,	300,	100,	'',	'',	'',	'',	587,	'',	'',	'tls',	1,	'public',	'windows',	3,	3,	1,	1,	5,	0,	10,	3,	1,	1,	80,	0,	'',	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	70,	80,	90,	'8.8.8.8',	1,	1,	1,	'lanman',	1,	1,	1,	1,	1,	'../',	1,	'',	'AIzaSyAmWrwv5iEaQYGoLfhswheZi-mrKbtGVKM',	'http://192.168.1.11:11434',	'gemma3:4b',	1,	1,	'gemini',	'modern_dark',	1,	1,	NULL,	NULL,	NULL,	'C:\\Program Files (x86)\\Nmapmap.exe',	'192.168.1.0/24',	5,	30,	NULL,	NULL,	NULL,	1);

DROP TABLE IF EXISTS `network_oui_lookup`;
CREATE TABLE `network_oui_lookup` (
  `oui` varchar(10) NOT NULL,
  `vendor_name` varchar(255) NOT NULL,
  PRIMARY KEY (`oui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_performance_summary`;
CREATE TABLE `network_performance_summary` (
  `asset_id` int(11) NOT NULL,
  `avg_latency` decimal(10,2) DEFAULT NULL,
  `max_latency` decimal(10,2) DEFAULT NULL,
  `last_check` datetime DEFAULT NULL,
  PRIMARY KEY (`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_services`;
CREATE TABLE `network_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `service_name` varchar(100) DEFAULT NULL,
  `service_desc` mediumtext,
  `https` enum('http','https') DEFAULT 'http',
  `port_number` int(11) NOT NULL,
  `link_type` enum('ip','service') DEFAULT 'ip',
  `is_docker` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `last_seen` timestamp NULL DEFAULT NULL,
  `status` varchar(20) DEFAULT 'online',
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `network_services_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `network_assets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `network_speed_log`;
CREATE TABLE `network_speed_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `check_time` datetime DEFAULT NULL,
  `download_mbps` decimal(10,2) DEFAULT NULL,
  `upload_mbps` decimal(10,2) DEFAULT NULL,
  `latency_ms` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_traces`;
CREATE TABLE `network_traces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_id` int(11) NOT NULL,
  `source_type` enum('asset','discovery') NOT NULL,
  `hop_position` int(11) NOT NULL,
  `hop_ip` varchar(45) NOT NULL,
  `hop_hostname` varchar(255) DEFAULT NULL,
  `latency_ms` decimal(10,2) DEFAULT NULL,
  `check_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`target_id`),
  KEY `idx_target_source` (`target_id`,`source_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `network_wake_log`;
CREATE TABLE `network_wake_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `ip_address` varchar(25) NOT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `mac_address` varchar(20) NOT NULL,
  `status` enum('success','failure','pending') DEFAULT 'pending',
  `attempt_count` int(11) DEFAULT '1',
  `next_check_at` datetime DEFAULT NULL,
  `wake_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_wake_asset` (`asset_id`),
  CONSTRAINT `fk_wake_asset` FOREIGN KEY (`asset_id`) REFERENCES `network_assets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `note_document_links`;
CREATE TABLE `note_document_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `note_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `note_doc_fk_doc` (`document_id`),
  KEY `note_doc_fk_note` (`note_id`),
  CONSTRAINT `note_doc_fk_doc` FOREIGN KEY (`document_id`) REFERENCES `asset_documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `note_doc_fk_note` FOREIGN KEY (`note_id`) REFERENCES `portal_notes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `ping_pong_scores`;
CREATE TABLE `ping_pong_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_name` varchar(50) NOT NULL,
  `player_score` int(11) NOT NULL,
  `computer_score` int(11) NOT NULL,
  `played_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `portal_folders`;
CREATE TABLE `portal_folders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(250) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `folder_name` varchar(100) NOT NULL,
  `folder_desc` varchar(250) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_pinned` tinyint(1) DEFAULT '0',
  `is_archived` tinyint(1) DEFAULT '0',
  `highlight_color` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `portal_folders_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `portal_folders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `portal_notes`;
CREATE TABLE `portal_notes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `folder_id` int(10) unsigned DEFAULT NULL,
  `target_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'general',
  `target_id` int(11) DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('low','medium','high','urgent') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `is_pinned` tinyint(1) DEFAULT '0',
  `is_archived` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `folder_id` (`folder_id`),
  KEY `idx_note_targets` (`target_type`,`target_id`),
  FULLTEXT KEY `ft_search` (`title`,`content`),
  CONSTRAINT `portal_notes_ibfk_1` FOREIGN KEY (`folder_id`) REFERENCES `portal_folders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `portal_notes_history`;
CREATE TABLE `portal_notes_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `note_id` int(10) unsigned NOT NULL,
  `content_snapshot` longtext NOT NULL,
  `version_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `note_id` (`note_id`),
  CONSTRAINT `portal_notes_history_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `portal_notes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `portal_note_tags`;
CREATE TABLE `portal_note_tags` (
  `note_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`note_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `portal_note_tags_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `portal_notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `portal_note_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `portal_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `portal_tags`;
CREATE TABLE `portal_tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL,
  `color_code` varchar(7) DEFAULT '#3498db',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_name` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sec_settings`;
CREATE TABLE `sec_settings` (
  `set_name` varchar(255) NOT NULL,
  `set_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sec_settings` (`set_name`, `set_value`) VALUES
('auth_sn_fb',	'N'),
('auth_sn_fb_app_id',	''),
('auth_sn_fb_secret',	''),
('auth_sn_google',	'N'),
('auth_sn_google_client_id',	''),
('auth_sn_google_secret',	''),
('auth_sn_position',	'beside'),
('auth_sn_x',	'N'),
('auth_sn_x_key',	''),
('auth_sn_x_secret',	''),
('brute_force',	'Y'),
('brute_force_attempts',	'10'),
('brute_force_time_block',	'10'),
('captcha',	'N'),
('cookie_expiration_time',	'30'),
('enable_2fa',	'Y'),
('enable_2fa_api',	'usr__NM__jamieoates'),
('enable_2fa_api_type',	'email'),
('enable_2fa_expiration_time',	'300'),
('enable_2fa_mode',	'individual'),
('group_administrator',	'1'),
('group_default',	'2'),
('language',	'N'),
('login_mode',	'both'),
('mfa_last_updated',	'30'),
('new_users',	'N'),
('password_min',	'5'),
('password_strength',	'uppercase_letter;lowercase_letter;numbers;special_chars'),
('pswd_last_updated',	'360'),
('recover_pswd',	'send_link'),
('remember_me',	'Y'),
('req_email_act',	'N'),
('retrieve_password',	'Y'),
('send_email_adm',	'Y'),
('session_expire',	'N'),
('smtp_api',	'usr__NM__jamieoates'),
('smtp_from_email',	''),
('smtp_from_name',	''),
('smtp_pass',	''),
('smtp_port',	'0'),
('smtp_security',	''),
('smtp_server',	''),
('smtp_user',	''),
('theme',	'lanman_v2');

DROP TABLE IF EXISTS `sec_users`;
CREATE TABLE `sec_users` (
  `login` varchar(255) NOT NULL,
  `pswd` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` varchar(1) DEFAULT NULL,
  `activation_code` varchar(32) DEFAULT NULL,
  `priv_admin` varchar(1) DEFAULT NULL,
  `mfa` varchar(255) DEFAULT NULL,
  `picture` longblob,
  `role` varchar(128) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `pswd_last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mfa_last_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `service_document_links`;
CREATE TABLE `service_document_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  CONSTRAINT `service_document_links_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `asset_documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP VIEW IF EXISTS `view_slow_assets`;
CREATE TABLE `view_slow_assets` (`id` int(11), `asset_name` varchar(255), `ip_address` varchar(45), `latency` decimal(10,2), `check_time` datetime);


DROP VIEW IF EXISTS `view_slow_assets_dynamic`;
CREATE TABLE `view_slow_assets_dynamic` (`id` int(11), `asset_name` varchar(255), `ip_address` varchar(45), `latency` decimal(10,2), `check_time` datetime, `latency_threshold_ms` int(11));


DROP TABLE IF EXISTS `view_slow_assets`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_slow_assets` AS select `a`.`id` AS `id`,`a`.`asset_name` AS `asset_name`,`a`.`ip_address` AS `ip_address`,`l`.`latency` AS `latency`,`l`.`check_time` AS `check_time` from (`network_assets` `a` join `network_log` `l` on((`a`.`id` = `l`.`asset_id`))) where ((`l`.`latency` > 200) and (`l`.`check_time` >= (now() - interval 24 hour)));

DROP TABLE IF EXISTS `view_slow_assets_dynamic`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_slow_assets_dynamic` AS select `a`.`id` AS `id`,`a`.`asset_name` AS `asset_name`,`a`.`ip_address` AS `ip_address`,`l`.`latency` AS `latency`,`l`.`check_time` AS `check_time`,`o`.`latency_threshold_ms` AS `latency_threshold_ms` from ((`network_assets` `a` join `network_log` `l` on((`a`.`id` = `l`.`asset_id`))) join `network_options` `o` on((`o`.`id` = 1))) where ((`l`.`latency` > `o`.`latency_threshold_ms`) and (`l`.`check_time` >= (now() - interval 24 hour)));
