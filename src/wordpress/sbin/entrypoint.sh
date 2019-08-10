#!/bin/bash
set -e

ping ${MYSQL_HOSTNAME:-press-up-mysql} -c 5

if [[ -n "$(ls /www 2>/dev/null)" ]]
then
  echo "[info] wordpress www directory, skipping creation"
else
  echo "[info] wordpress www directory not found, creating initial config"

  if [[ -n "${S3_WORDPRESS_BUCKET}" ]]; then
    restore_file=$(aws s3api list-objects --bucket ${S3_WORDPRESS_BUCKET} --query "reverse(sort_by(Contents,&LastModified))" | jq -r ".[].Key" | grep index.php | head -n 1);
  fi

  if [[ -n "${restore_file}" ]]; then
    echo "[info] Restore from S3 sync..."
    aws s3 sync s3://${S3_WORDPRESS_BUCKET}/ /init/www/wordpress
    mv /init/www/wordpress /www
  else
    echo "[info] Staring fresh wordpress installation"
    curl -o /init/wordpress.tar.gz ${WP_RELEASE_URL}

    ls /init
    tar -C /init -xzvf /init/wordpress.tar.gz
    mv /init/wp-config.php /init/wordpress

    curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /init/wordpress/wp-config.php
    echo "require_once(ABSPATH . 'wp-settings.php');"  >> /init/wordpress/wp-config.php

    mv /init/wordpress /www
  fi

  rm -rf /init

  mkdir -p /www/wordpress/wp-content/upgrade

  touch /www/.htaccess
  touch /www/wordpress/.htaccess

  chown -R www-data:www-data /www

  echo "[info] initial config complete"
fi

(. /sbin/backup-runner.sh) &

apache2ctl configtest
source ../etc/apache2/envvars

exec apache2 -D FOREGROUND
