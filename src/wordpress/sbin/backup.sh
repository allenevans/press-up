#!/usr/bin/env bash

declare -a REQUIRED_ENV_VARS=(
  "S3_BACKUP_BUCKET"
)

for env_var in "${REQUIRED_ENV_VARS[@]}"
do
  if [[ -z "$(eval "echo \${${env_var}}")" ]]
  then
    echo "[error] required environment variable ${env_var} is empty"
    exit 1
  fi
done

if [[ "${?}" -eq 0 ]] && [[ "${BACKUP_ENABLED}" = "true" ]]; then
  echo "[info] $(date +'%F %T%z') wordpress backup start"

  aws s3 sync /www/wordpress/ "s3://${S3_BACKUP_BUCKET}/wordpress/"

  if [[ "${?}" -eq 0 ]]; then
    echo "[info] $(date +'%F %T%z') wordpress backup complete"
  else
    echo "[error] $(date +'%F %T%z') failure backing up wordpress"
    exit 1
  fi
fi
