#!/bin/bash
# Simple log monitor that looks for keywords in a target log
set -euo pipefail
source "$(dirname "$0")/lib_common.sh"

LOG="log_monitor.log"
TARGET_LOG="/var/log/syslog"
PATTERN="error|fail|critical|unable"
SIZE_THRESHOLD_MB=50

log "$LOG" "Starting log monitor for $TARGET_LOG"

if [ -f "$TARGET_LOG" ]; then
  recent_matches=$(sudo tail -n 1000 "$TARGET_LOG" 2>/dev/null | grep -iE "$PATTERN" || true)
  if [ -n "$recent_matches" ]; then
    log "$LOG" "Pattern matches found in $TARGET_LOG (top 20 lines):"
    echo "$recent_matches" | sed -n '1,20p' >> "$(logfile_for "$LOG")"
    # Example email alert (requires mailutils & configured MTA):
    # echo "$recent_matches" | mail -s "Log Alert" you@example.com
  else
    log "$LOG" "No pattern occurrences found"
  fi

  size_mb=$(du -m "$TARGET_LOG" | cut -f1)
  if [ "$size_mb" -gt "$SIZE_THRESHOLD_MB" ]; then
    log "$LOG" "Warning: $TARGET_LOG size ${size_mb}MB > ${SIZE_THRESHOLD_MB}MB"
  fi
else
  log "$LOG" "Target log $TARGET_LOG not found. Update TARGET_LOG variable if needed."
fi

log "$LOG" "Log monitor finished"
EOF
