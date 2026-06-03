# User documentation

## Overview
The stack provides a WordPress website accessible over HTTPS via the NGINX
reverse proxy (TLS on port 443). The MariaDB database stores WordPress data.
WordPress is pre-installed with one administrator account and one regular user.

## Start / Stop
Start:

```bash
make all
```

Stop:

```bash
make clean
```

Remove volumes (data):

```bash
make fclean
```

## Access
Point your browser to `https://hchowdhu.42.fr` (or the DOMAIN_NAME in
`srcs/.env`). The site is installed automatically on first start.

The admin panel is available at `/wp-admin` after logging in with the
administrator account configured in the local secrets.

## Credentials and secrets
All sensitive values are stored in local files in the `secrets/` folder or via
Docker secrets. Do not commit those files to git.

The WordPress passwords live in `secrets/credentials.txt`; the database
passwords live in `secrets/db_password.txt` and `secrets/db_root_password.txt`.

## Checking services
Use `docker compose -f srcs/docker-compose.yml ps` to see service status.
