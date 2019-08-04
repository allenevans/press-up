#!/bin/bash
set -e

mysqld --version

mkdir -p mkdir /var/run/mysqld

if [[ -n "$(ls -A /db 2>/dev/null)" ]]
then
  echo "[info] MySql directory already present, skipping creation"
else
  echo "[info] MySql data directory not found, creating initial DBs"
  mysqld --initialize-insecure
  (. /sbin/mysql-config.sh) &
fi

(. /sbin/backup-runner.sh) &

exec mysqld_safe
