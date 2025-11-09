#!/bin/bash
# Menu-driven script runner
set -euo pipefail
source "$(dirname "$0")/lib_common.sh"

SCRIPTDIR="$(dirname "$0")"
PS3="Choose an option: "

options=(
  "Run backup"
  "Run system update & cleanup"
  "Run log monitor"
  "Run all (backup + update + monitor)"
  "Show latest logs"
  "Schedule daily backup (cron)"
  "Exit"
)

while true; do
  echo "=== Maintenance Suite ==="
  select opt in "${options[@]}"; do
    case $REPLY in
      1) bash "$SCRIPTDIR/backup.sh"; break ;;
      2) bash "$SCRIPTDIR/system_maint.sh"; break ;;
      3) bash "$SCRIPTDIR/log_monitor.sh"; break ;;
      4) bash "$SCRIPTDIR/backup.sh" && bash "$SCRIPTDIR/system_maint.sh" && bash "$SCRIPTDIR/log_monitor.sh"; break ;;
      5) ls -1 "$HOME/maint_suite/maint_logs" || true; read -rp "Which log to view (filename): " lf; less "$HOME/maint_suite/maint_logs/$lf"; break ;;
      6)
         echo "Scheduling daily backup at 02:00 (user crontab)"
         (crontab -l 2>/dev/null; echo "0 2 * * * $SCRIPTDIR/backup.sh >/dev/null 2>&1") | crontab -
         echo "Crontab entry added"
         break
         ;;
      7) echo "Goodbye"; exit 0 ;;
      *) echo "Invalid choice"; break ;;
    esac
  done
done
