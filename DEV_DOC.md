# Dev Doc

## Needed
- Docker
- Docker Compose
- make

## Configuration
1. cp srcs/template.env srcs/.env
2. fill srcs/.env fields
3. Create secrets/ folder with :
   - db_root_password.txt
   - db_user_password.txt
   - wp_admin_password.txt
   - wp_user_password.txt

## Launch
make

## Commands utils
make up     *start all services*
make down   *stop all services*
make status *check all status*
make clean  *stop container, delete all images, named volumes and orphans*
make fclean *clean + delete data inside bind mounted volumes*
make re     *remove all and rebuilt new one*

## Without make
cd srcs
docker compose up -d --build
docker compose down

## Data
Docker Volumes store :
- MariaDB data
- WordPress folders

## See volumes:
docker volume ls
