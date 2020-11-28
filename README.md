# Press-up

## What is it?
Docker composable Wordpress and MySql with automated AWS S3 backup and restore.

## Requirements
* Docker *(tested with v19.03.1)*
* Docker compose *(tested with 1.24.1)*
* Node.js v8 or above *(optional)*

## Environment variables
* [MySql environment variables](src/mysql/README.md#runtime-environment-variables)
* [Wordpress environment variables](src/wordpress/README.md#runtime-environment-variables)

Environment variables can be hard coded into [`docker-compose.yml`](src/docker-compose.yml), or loaded from
an environment variables file. See docker compose documentation for more information. 

*Tip: tools such as [direnv](https://direnv.net/) can help manage your environment variables during development, and useful for keeping
secrets such as AWS credentials out of source control.*

## Commands
To ease getting started, the following `npm` commands are provided:-

* `npm start`
  - Uses `docker-compose` to spin up MySql and Wordpress docker containers
* `npm run stop`
  - Stop MySql and Wordpress docker containers
* `npm run start:mysql`
  - Only start the MySql server container
* `npm run start:wordpress`
  - Only start the Wordpress server container
  - *Tip: when trying to connect to MySql instance already running on the same machine, set `MYSQL_HOSTNAME=host.docker.internal`* 
* `npm run clean`
  - __Only use if you understand the risks__
  - Destructive operation that forcefully prunes docker images, containers and volumes
  - Always make sure you have the appropriate backups first
  - Useful prior to building to ensure no cached layers are used, and images are downloaded again
* `npm run build`
  - Build MySql and Wordpress container images
* `npm run build:base`
  - Only build the common base image
* `npm run build:wordpress`
  - Only build the MySql image
* `npm run build:wordpress`
  - Only build the MySql image

It is not a hard requirement to have `npm` available to be able to run the necessary docker commands.
Take a look at the `scripts` block in [`package.json`](package.json) for more information.

## Docker images
* [Base](src/base/README.md)
* [MySql database](src/mysql/README.md)
* [Wordpress](src/wordpress/README.md)
