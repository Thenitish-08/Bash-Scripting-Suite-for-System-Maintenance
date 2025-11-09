#!/bin/bash
# Shared helpers for maint_suite
set -euo pipefail

LOGDIR="${HOME}/maint_suite/maint_logs"
BACKUPDIR="${HOME}/maint_suite/maint_backups"
SCRIPTDIR="${HOME}/maint_suite/scripts"
mkdir -p "$LOGDIR" "$BACKUPDIR"

timestamp(){ date +'%F %T'; }
logfile_for(){ echo "$LOGDIR/$1"; }  # pass base filename, e.g. backup.log
log(){ local f="$1"; shift; echo "[$(timestamp)] $*" | tee -a "$(logfile_for "$f")"; }
cmd_exists(){ command -v "$1" >/dev/null 2>&1; }
trap_on_exit(){
  local rc=$?
  if [ $rc -ne 0 ]; then
    echo "[$(timestamp)] Script failed with exit code $rc" >> "$(logfile_for "errors.log")"
  fi
  exit $rc
}
trap 'trap_on_exit' EXIT
EOF
