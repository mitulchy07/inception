# User documentation

## Overview
The stack provides a WordPress website accessible over HTTPS via the NGINX
reverse proxy (TLS on port 443). The MariaDB database stores WordPress data.

## Start / Stop
Start:

```bash
make all
```

Stop:

```bash
make down
```

Remove volumes (data):

```bash
make fclean
```

## Access
Point your browser to `https://hchowdhu.42.fr` (or the DOMAIN_NAME in
`srcs/.env`) and complete the WordPress setup.

## Credentials and secrets
All sensitive values are stored in local files in the `secrets/` folder or via
Docker secrets. Do not commit those files to git.

## Checking services
Use `docker compose -f srcs/docker-compose.yml ps` to see service status.
