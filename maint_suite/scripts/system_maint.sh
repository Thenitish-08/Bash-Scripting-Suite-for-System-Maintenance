#!/bin/bash
# System update/cleanup (Ubuntu/Debian)
set -euo pipefail
source "$(dirname "$0")/lib_common.sh"

LOG="system_maint.log"
log "$LOG" "Starting system maintenance"

if cmd_exists apt; then
  log "$LOG" "Running apt update && upgrade"
  sudo apt update 2>>"$(logfile_for "$LOG")" || { log "$LOG" "apt update failed"; exit 1; }
  sudo DEBIAN_FRONTEND=noninteractive apt -y upgrade 2>>"$(logfile_for "$LOG")" || { log "$LOG" "apt upgrade failed"; exit 1; }
  sudo apt -y autoremove 2>>"$(logfile_for "$LOG")" || true
  sudo apt -y autoclean 2>>"$(logfile_for "$LOG")" || true
else
  log "$LOG" "No apt found. Skipping package maintenance."
fi

log "$LOG" "System maintenance finished"
EOF
