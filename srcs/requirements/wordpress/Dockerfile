FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y wget unzip php-fpm php-mysql php-xml php-cgi libzip-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget -q https://wordpress.org/latest.tar.gz \
 && tar xzf latest.tar.gz --strip-components=1 \
 && rm latest.tar.gz

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
