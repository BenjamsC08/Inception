# Inception
*This Project has been created as part of the 42 curriculum by Benjamsc*

## Description
### Goal
In this project we need to setup a small infrastructure composed of different
services, that ones contains 3, [MariaDb](https://mariadb.org), [Wordpress](https://wordpress.com), [Nginx](https://nginx.org). 
We have to run them inside containers [Docker](https://www.docker.com).
### Constraints
We need to do a Dockerfile for each services, and it's forbidden to pull the official images.
The coordinations of all dockers will be done by docker compose, so we need a `.yml` in 
the root of the project, all containers need to use a docker-network to comunicate.
#### Nginx
- TLSv1.2 or TLSv1.3 only
#### Wordpress
- configure with php-fpm, without nginx
- a persistent volume for wordpress website files.
#### MariaDb
- alone inside the docker without nginx
- a persistent volume for database
#### Volumes
- use named volumes, binds mounts are not allowed.
- volume path will be /home/login/data

### Overviewtertup](https://github.com/BenjamsC08/incaption/blob/main/Data/Screenshot%20from%202026-07-29%2008-43-11.png)

### Other points
#### Virtual machines vs Docker
#### Secrets vs Environment Variables
#### Docker Network vs Host Network
#### Docker volumes  vs Bind Mounts


## Instructions
To use this project, you need to install [docker(setup)](https://docs.docker.com/engine/install/) on your computer.
Clone the repo, go into it.
first thing you need to set a `.env` file in srcs u can copy `template.env`
all variable are into it, you just need to change all fields, and call the file `.env`
few commands to use Inception:
- `make`/`make up` will instantiate the projet and run it
- `make down` will destroy all the containers and images (keep volumes)
- `make start` will relaunch all containers if they're only stopped
- `make stop` will only stopped containers without remove something

If you wanna dig more feel free to check
- [USER_DOC.md](https://github.com/BenjamsC08/incaption/blob/main/Data/USER_DOC.md)
- [DEV_DOC.md](https://github.com/BenjamsC08/incaption/blob/main/Data/DEV_DOC.md)

## Ressources

### English
- [Nginx Official Docs](https://nginx.org/en/docs/)
- [Mariadb official Docs](https://mariadb.org)
- [Wordpress official Docs](https://wordpress.org/documentation/)
- [Docker compose restart policies](https://oneuptime.com/blog/post/2026-02-08-how-to-use-docker-compose-restart-policy-options/view)
- [Creating a Dockerfile](https://softchris.github.io/pages/docker-one.html#creating-a-dockerfile)
- [MariaDb env Var](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/mariadb-server-docker-official-image-environment-variables#environment-variables)
### French
- [Containerization and lot of docker data](https://blog.stephane-robert.info/docs/conteneurisation/)

