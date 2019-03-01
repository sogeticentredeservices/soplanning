Soplanning Docker image
=======================

[![pipeline status](http://git.centre-de-services.cf/devops/docker/soplanning/badges/master/pipeline.svg?style=flat-square)](http://git.centre-de-services.cf/devops/docker/soplanning/commits/master)

![logo](https://www.soplanning.org/wp-content/uploads/2017/05/logo-soplanning.png)

SO Planning is a Simple Online Planning tool. Allows you to plan working periods for each person of your team.

Using this image
----------------

### Usage

Start SOplanning with default options:

```console
$ docker run -p 8080:80 \
	 --link mysql:mysql -e "MYSQL_ROOT_PASSWORD=example" \
	 registry.centre-de-services.cf:4567/devops/docker/soplanning:latest
```

Start SOplanning with an existing database:

```console
$ docker run -p 8080:80 \
	 --link mysql:mysql \
         -e "MYSQL_HOST=mysql" \
         -e "MYSQL_DATABASE=soplanning" \
         -e "MYSQL_USER=soplanning" \
         -e "MYSQL_PASSWORD=example" \
	 registry.centre-de-services:4567/devops/docker/soplanning:latest
```

This will store the application in /var/www/html. There is no need to make a volume for it. SOplanning configurations are stored on the database.

### Environment Variables

-	`MYSQL_HOST` - Host to mysql database
-	`MYSQL_DATABASE` - Name of the database to be used
-	`MYSQL_USER` - Mysql user
-	`MYSQL_PASSWORD` - Mysql user's password

### Exposed Ports

-	80 TCP -- HTTP API endpoint

### ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml` for `soplanning`:

```yaml
# Use root/example as user/password credentials
version: '3.1'

services:

  soplanning:
    image: registry.centre-de-services.cf:4567/devops/docker/soplanning
    environment:
      MYSQL_HOST:     mysql
      MYSQL_DATABASE: soplanning
      MYSQL_USER:     soplanning
      MYSQL_PASSWORD: example
    ports:
      - 8080:80
    restart: always

  mysql:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE:      soplanning
      MYSQL_USER:          soplanning
      MYSQL_PASSWORD:      example
    restart: always
```
