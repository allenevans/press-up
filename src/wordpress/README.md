# Press up Wordpress
A wordpress docker image with automated backups using S3.

## Runtime environment variables
* `AWS_ACCESS_KEY_ID`
  - See [Configuring the AWS CLI » Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
* `AWS_REGION`
  - See [Configuring the AWS CLI » Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
* `AWS_SECRET_ACCESS_KEY`
  - See [Configuring the AWS CLI » Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
* `BACKUP_ENABLED=[true|false]` *default = false*
  - Boolean flag to enable backups to S3 
* `BACKUP_INTERVAL=<number>` *default = 86400 (1 day)* 
  - Number of seconds to elapse between database backups
* `MYSQL_HOSTNAME`  *default = 'mysql'*
  - MySql server host name
* `MYSQL_WP_DATABASE`
  - Name of the wordpress database
* `MYSQL_WP_PASS`
  - Password for the wordpress user
* `MYSQL_WP_USER`
  - User to authenticate to the wordpress database
* `S3_WORDPRESS_BUCKET`
  - S3 bucket name to write and restore backup files from
* `WP_HOME`
  - Wordpress home url. *default http://localhost:8888*
* `WP_RELEASE_URL`
  - [Wordpress release](https://wordpress.org/download/releases/) to use for fresh installations
* `WP_SITEURL`
  - Wordpress site url. *default http://localhost:8888*
