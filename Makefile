NAME = inception
SRC = srcs
COMPOSE = docker compose -p $(NAME) -f $(SRC)/docker-compose.yml

.PHONY: all build up down clean fclean re logs

all: build up

build:
	$(COMPOSE) build --parallel

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean: down

fclean: clean
	docker volume rm $(NAME)_wordpress_files || true
	docker volume rm $(NAME)_wordpress_db || true

re: fclean all

logs:
	$(COMPOSE) logs -f
