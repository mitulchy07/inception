*This project has been created as part of the 42 curriculum by hchowdhu.*

# Inception

## Description
This project demonstrates a small Docker-based infrastructure for running a
WordPress site with MariaDB and an NGINX TLS reverse proxy. It follows the
42-school requirements: each service runs in its own container, uses Debian-based
images, named Docker volumes for persistence, and Docker Compose orchestration.
The final stack exposes only HTTPS on port 443 and automatically installs
WordPress with one administrator and one regular user.

## Instructions
From the repository root:

```bash
make all
```

This builds images and starts the stack. Use `make clean` to stop it and `make fclean`
to remove the named volumes created by this project.

Configuration values are in `srcs/.env` and secrets are kept in the `secrets/`
directory (ignored by git).

## Project description
- Docker is used to containerize services: MariaDB, WordPress (php-fpm only), and
  NGINX (TLS termination).
- Volumes: persistent storage is implemented as named volumes mapped to
  `/home/hchowdhu/data/...` on the host (driver local with bind).
- Service images are named after the service itself: `mariadb`, `wordpress`,
  and `nginx`.

### Design choices and comparisons
- Virtual Machines vs Docker: Docker provides lightweight isolation and faster
  deployment for micro-services; VMs provide stronger isolation and full OS
  environments.
- Secrets vs Environment Variables: Use `.env` for non-sensitive configuration
  and Docker secrets for confidential data (credentials) when available.
- Docker Network vs Host Network: Bridge networks provide isolation and
  service-name DNS; host networking exposes host network stack and is less
  isolated.
- Docker Volumes vs Bind Mounts: Named volumes are preferred for portability
  and Docker-managed lifecycle; bind mounts directly expose host paths.

## Resources
- Docker docs: https://docs.docker.com/
- WordPress docs: https://wordpress.org/support/
- WP-CLI docs: https://wp-cli.org/

## AI usage
AI was used to scaffold the initial project files and provide example Dockerfiles
and documentation.