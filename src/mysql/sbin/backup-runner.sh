#!/usr/bin/env bash

if [[ "${BACKUP_ENABLED:-false}" != "true" ]]; then
  echo [warn] Backups not enabled
  exit 0
fi

echo "[info] backups enabled to run every ${BACKUP_INTERVAL:-86400} seconds"

while true; do
  sleep ${BACKUP_INTERVAL:-86400}
  /sbin/backup.sh >> /var/log/backup.log 2>&1
  echo "[info] $(date +'%F %T%z') backup completed with exit code ${?}"
done
