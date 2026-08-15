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
make up
make down
make status
make fclean
make re

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
