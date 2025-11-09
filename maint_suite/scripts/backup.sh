#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGDIR="$HOME/maint_suite/maint_logs"
BACKUPDIR="$HOME/maint_suite/maint_backups"

mkdir -p "$LOGDIR" "$BACKUPDIR"

LOG="$LOGDIR/backup.log"
RETENTION_DAYS=7
DATE=$(date +%Y-%m-%d_%H-%M)
TMP_ARCHIVE="/tmp/backup-$DATE.tar.gz"
FINAL_ARCHIVE="$BACKUPDIR/backup-$DATE.tar.gz"
SRC_DIRS=( "$HOME" )

EXCLUDES=(
  "$BACKUPDIR"
  "$LOGDIR"
  "$HOME/.cache"
  "$HOME/.local/share/Trash"
  "$HOME/node_modules"
  "/proc" "/sys" "/dev" "/run" "/tmp" "/mnt"
)

# === Helper Functions ===
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
  echo "[$(timestamp)] $*" | tee -a "$LOG"
}

# === Backup Process ===
log "================= Starting Backup ================="
log "Date: $DATE"
log "Source: ${SRC_DIRS[*]}"
log "Excluding: ${EXCLUDES[*]}"

EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do
  EXCLUDE_ARGS+=( "--exclude=$e" )
done

# Check for tar availability
if ! command -v tar &>/dev/null; then
  log "Error: 'tar' command not found. Exiting."
  exit 2
fi

# Create temporary backup archive
log "Creating temporary archive at $TMP_ARCHIVE ..."
if tar --warning=no-file-changed --ignore-failed-read -czf "$TMP_ARCHIVE" \
  "${EXCLUDE_ARGS[@]}" "${SRC_DIRS[@]}" 2>>"$LOG"; then
  log "Created temporary archive successfully."
else
  log "tar finished with warnings. Check $LOG for details."
fi

# Move archive to final location if successful
if [[ -f "$TMP_ARCHIVE" && -s "$TMP_ARCHIVE" ]]; then
  mv "$TMP_ARCHIVE" "$FINAL_ARCHIVE"
  log "Backup successfully saved to $FINAL_ARCHIVE"
else
  log "Error: No archive created. Backup aborted."
  exit 1
fi

# === Cleanup Old Backups ===
log "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUPDIR" -type f -name 'backup-*.tar.gz' -mtime +"$RETENTION_DAYS" \
  -print -delete >>"$LOG" 2>&1 || log "Warning: Cleanup encountered errors."

log "================= Backup Completed ================="
