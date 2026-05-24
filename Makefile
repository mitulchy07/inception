NAME = inception
SRC = srcs

.PHONY: all build up down clean fclean re logs

all: build up

build:
	docker compose -f $(SRC)/docker-compose.yml build --parallel

up:
	docker compose -f $(SRC)/docker-compose.yml up -d

down:
	docker compose -f $(SRC)/docker-compose.yml down

clean: down

fclean: clean
	docker volume rm $(NAME)_wordpress_files || true
	docker volume rm $(NAME)_wordpress_db || true

re: fclean all

logs:
	docker compose -f $(SRC)/docker-compose.yml logs -f
