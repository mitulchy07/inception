# Developer documentation

## Prerequisites
- Docker Engine
- Docker Compose v2 (compose CLI)

## Setup from scratch
1. Place confidential values in `secrets/` and `srcs/.env`.
2. Fill `secrets/credentials.txt` with the WordPress admin and subscriber
	passwords.
3. From repository root run:

```bash
make all
```

## Useful commands
- `docker compose -f srcs/docker-compose.yml logs -f` — follow logs
- `docker compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p` — open DB
- `docker volume inspect srcs_wordpress` — inspect the WordPress volume
- `docker volume inspect srcs_mariadb` — inspect the MariaDB volume

## Data location
Named volumes are configured to store data under `/home/hchowdhu/data/` on the
host. The WordPress site files are stored in the `srcs_wordpress` volume and the
DB in the `srcs_mariadb` volume.

The WordPress container seeds `/var/www/html` from the image copy on first
startup, then preserves the generated config and content in the volume.
