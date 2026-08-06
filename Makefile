COMPOSE  = docker compose -f srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

.PHONY: all build up down stop start clean fclean re data

all: data build up

data:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

clean: down
	$(COMPOSE) down --rmi all --volumes --remove-orphans

fclean: clean
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

eval:
	docker stop $$(docker ps -qa) 2>/dev/null || true
	docker rm $$(docker ps -qa) 2>/dev/null || true
	docker rmi -f $$(docker images -qa) 2>/dev/null || true
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true

re: fclean all
