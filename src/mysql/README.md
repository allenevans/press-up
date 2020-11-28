# Press up MySql
A MySql docker image with automated backups using S3

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
* `MYSQL_WP_DATABASE`
  - Name of the wordpress database
* `MYSQL_WP_PASS`
  - Password for the wordpress user
* `MYSQL_WP_USER`
  - User to authenticate to the wordpress database
* `MYSQL_ROOT_PASSWORD`
  - `root` user password.
  - Set if you need access to the MySql instance outside of the running docker container
* `S3_MYSQL_BUCKET`
  - S3 bucket name to write and restore backup files from

## Backups
To enable backups, set `BACKUP_ENABLED=true`, specify `S3_MYSQL_BUCKET` and ensure the running container is authorized
to sync up to the AWS bucket 

### Backup process
1. Do `mysqldump` of the wordpress database specified by `MYSQL_WP_DATABASE`
2. `.tar.gz` the sql file and assign the day of the week in the file name. E.g. *mysql.Sat.tar.gz*
3. Copy (overwrite) the file into the S3 bucket specified by `S3_MYSQL_BUCKET`

By default, this will generate up to 7 database backups stored in S3, one for each day of the week

Backup activity logs can be found in `/var/log/backup.log`. 

E.g.

```bash
docker exec <container_id> tail -100 /var/log/backup.log
```

### Automatic restore
When the docker container starts, if `S3_MYSQL_BUCKET` has been specified then the initialisation entry script will attempt
to connect to S3, look for the latest database dump and if it exists, restore it.
