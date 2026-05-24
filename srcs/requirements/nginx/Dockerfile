FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y nginx openssl gettext-base \
 && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/ssl/private /etc/ssl/certs

# Generate a self-signed certificate (for development/testing)
RUN openssl req -x509 -nodes -days 365 \
 -subj "/CN=hchowdhu.42.fr" \
 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key \
 -out /etc/ssl/certs/nginx.crt

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
