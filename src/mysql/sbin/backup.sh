#!/usr/bin/env bash

declare -a REQUIRED_ENV_VARS=(
  "MYSQL_WP_DATABASE"
  "MYSQL_ROOT_PASSWORD"
  "S3_MYSQL_BUCKET"
)

for env_var in "${REQUIRED_ENV_VARS[@]}"
do
  if [[ -z "$(eval "echo \${${env_var}}")" ]]
  then
    echo "[error] required environment variable ${env_var} is empty"
    exit 1
  fi
done

echo "[info] $(date +'%F %T%z') Mysql Backup Start"

cd /tmp
sql_file="mysql-dump.sql"
archive_file="mysql.$(date +%a).tar.gz"

mysqldump \
  -u root \
  --password="${MYSQL_ROOT_PASSWORD}" \
  ${MYSQL_WP_DATABASE} > ${sql_file}

if [[ "${?}" -eq 0 ]]; then
  tar -zcvf ${archive_file} ${sql_file}

  aws s3 cp ${archive_file} "s3://${S3_MYSQL_BUCKET}"

  rm ${archive_file}
  rm ${sql_file}

  echo "[info] $(date +'%F %T%z') mysql Backup Complete: ${archive_file}"
else
  echo "[error] $(date +'%F %T%z') failure backing up mysql"
  exit 1
fi
