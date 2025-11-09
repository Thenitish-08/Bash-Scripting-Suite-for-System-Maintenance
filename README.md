📖 Overview
This project automates routine system maintenance tasks such as backups, system updates, cleanup, and log monitoring using Bash scripting.
It is implemented in Ubuntu running under Windows Subsystem for Linux (WSL), combining the power of Linux automation with Windows accessibility.

The automation suite provides:

Scheduled system updates and cleanups
Automated backups with retention policy
Log file monitoring for critical errors
A menu-driven interface for easy control
Full logging for auditing and troubleshooting
🎯 Objectives
Automate essential system maintenance tasks using Bash scripts.
Ensure data safety through periodic backups.
Monitor system logs for error patterns automatically.
Provide a user-friendly command-line interface.
Schedule all tasks using cron (Linux) or Task Scheduler (Windows).
⚙️ Features
Feature	Description
🧩 Modular Scripts	Separate scripts for backup, updates, and log monitoring
🪶 Central Logging	Every script writes detailed logs in maint_logs/
🗂️ Retention Policy	Old backups automatically removed after 7 days
🖥️ Interactive Menu	Simple terminal menu to run and view tasks
⏰ Automated Scheduling	Supports both cron and Windows Task Scheduler
🔐 Cross-Platform	Runs seamlessly under Ubuntu WSL on Windows
🏗️ Project Structure
maint_suite/ │ ├── maint_backups/ # Stores compressed backup files ├── maint_logs/ # Contains log files for all scripts └── scripts/ # Core automation scripts ├── lib_common.sh ├── backup.sh ├── system_maint.sh ├── log_monitor.sh └── maint_menu.sh

📜 Script Descriptions lib_common.sh Contains reusable helper functions for logging, error handling, and environment setup.

backup.sh Creates compressed backups of important directories. Automatically removes backups older than 7 days.

system_maint.sh Runs apt update, upgrade, autoremove, and autoclean. Keeps system packages updated and storage clean.

log_monitor.sh Monitors /var/log/syslog for keywords like error, fail, critical. Can send alerts or log warnings.

maint_menu.sh Provides a menu-driven interface to execute all tasks interactively. Offers options to schedule daily backups via cron

📊 Results

✅ Backup archives created automatically
✅ System updates and cleanup completed without errors
✅ Log monitoring detected simulated error patterns 
✅ Automatic execution verified via cron and Task Scheduler
✅ Logs recorded in maint_logs/

🚀 Future Enhancements

Cloud backup support (Google Drive / AWS S3) GUI version using Python or Zenity Slack/Telegram notifications for log alerts Incremental backups using rsync

🧑‍💻 Author

Nitish Kumar
📅 November 2025 
💬 “Automating today for a smoother tomorrow.”
