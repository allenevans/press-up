#!/bin/bash
set -e

declare -a REQUIRED_ENV_VARS=(
  "MYSQL_WP_DATABASE"
  "MYSQL_WP_USER"
  "MYSQL_WP_PASS"
)

for env_var in "${REQUIRED_ENV_VARS[@]}"
do
  if [[ -z "$(eval "echo \${${env_var}}")" ]]
  then
    echo "[error] required environment variable ${env_var} is empty"
    exit 1
  fi
done

# Scripts to run on database initialisation
init_db_scripts=(
  "/init/list-databases.sql"
)

tmp_file=`mktemp`
mysql_root_password=${MYSQL_ROOT_PASSWORD:-$(openssl rand -base64 16)}

# Wait for MySql to be available
sleep 5
until nc -z -v -w30 "127.0.0.1" 3306
do
  echo "[info] waiting for database connection..."
  sleep 5
done

# Configure MySql users
cat << EOF > ${tmp_file}
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "${mysql_root_password}" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
UPDATE user SET authentication_string=PASSWORD("${mysql_root_password}") WHERE user='root';

CREATE DATABASE ${MYSQL_WP_DATABASE} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON ${MYSQL_WP_DATABASE}.* TO '${MYSQL_WP_USER}'@'%' IDENTIFIED BY '${MYSQL_WP_PASS}';
UPDATE user SET authentication_string=PASSWORD('${MYSQL_WP_PASS}') WHERE user='${MYSQL_WP_USER}';

FLUSH PRIVILEGES;
EOF

echo "[info] execute user statements"
mysql --user=root --skip-password < ${tmp_file}

# Check for S3 backup file to restore from
if [[ -n "${S3_MYSQL_BUCKET}" ]]; then
  restore_file=$(aws s3api list-objects --bucket ${S3_MYSQL_BUCKET} --query "reverse(sort_by(Contents,&LastModified))" | jq -r ".[].Key" | grep mysql | head -n 1);
fi

if [[ ${restore_file:-''} != '' ]]
then
  echo "[info] restore from S3 ${restore_file}..."

  aws s3 cp s3://${S3_MYSQL_BUCKET}/${restore_file} /init/mysql.tar.gz
  tar -C /init -xzvf /init/mysql.tar.gz

  echo "USE wordpress;" > ${tmp_file}
  cat '/init/mysql-dump.sql' >> ${tmp_file}

  mysql --user=root --password="${mysql_root_password}" < ${tmp_file}
  echo "[info] restore complete"
fi

rm -f ${tmp_file}

for script in ${init_db_scripts[@]}
do
  echo "[info] executing init db script ${script}"
  mysql --user=root --password="${mysql_root_password}" < ${script}
done
