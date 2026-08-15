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

### Overview
![setup](https://github.com/BenjamsC08/incaption/blob/main/data/Screenshot%20from%202026-07-29%2008-43-11.png)

### Other points
#### Virtual machines vs Docker
The main difference is the weight of these, a virtual machine is really heavy, and vm are really human-usage focused where the docker (or containers in general) are more lightweight and service-focused.
Docker is layered each Dockerfile [instructions](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/#common-instructions) adds a layer. If a Dockerfile is modified, Docker will rebuild from the modified layer to the end of the Docker file (that's why we put apt update and apt install in the same layer).
#### Secrets vs Environment Variables
Environment variables are accessible from all processes within the container and can be viewed using `docker inspect`; all child processes inherit these variables. Secrets are mounted into the container via `tmpfs`; child processes cannot access this file. There is no incompatibility; these two mechanisms work well together.
#### Docker Network vs Host Network
The main difference is that a Host Network will use the ip of the host, but in a Docker Network it will have its own. Docker Network will really isolate the container. With Docker Network, you can use different port inside and outside of the docker, (ex: you can use 8080 outside so all devices on my host network will see it on this port, but inside the docker the service provided will used 80). Communication between docker will be faster and smoother inside a Docker network because they can use the ip of each, in host network they're all on localhost.
#### Docker volumes  vs Bind Mounts
Docker volumes are more portable, they're manage by docker, including permission, creation; they're easier to backup or migrate with docker volumes and they're more isolated than bind mounts. Bind mounts are more useful for things like source code configs or something that already exists that you want to use.


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
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [Creating a Dockerfile](https://softchris.github.io/pages/docker-one.html#creating-a-dockerfile)
- [MariaDb env Var](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/mariadb-server-docker-official-image-environment-variables#environment-variables)
### French (but it really helped me)
- [Containerization and lot of docker data](https://blog.stephane-robert.info/docs/conteneurisation/)

## IA USAGE
AI was used to search for documents; it also helped me correct certain initialization scripts—particularly the WordPress one—and likely helped with proofreading, even though scribens.fr doesn't explicitly state that it uses AI.
