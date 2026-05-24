# Developer documentation

## Prerequisites
- Docker Engine
- Docker Compose v2 (compose CLI)

## Setup from scratch
1. Place confidential values in `secrets/` and `srcs/.env`.
2. From repository root run:

```bash
make all
```

## Useful commands
- `make logs` — follow logs
- `docker compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p` — open DB
- `docker volume inspect inception_wordpress_files` — inspect named volume

## Data location
Named volumes are configured to store data under `/home/hchowdhu/data/` on the
host. The WordPress site files are in the `wordpress_files` volume and the DB in
`wordpress_db`.
