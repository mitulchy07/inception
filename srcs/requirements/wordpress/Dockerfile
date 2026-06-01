FROM debian:11

RUN apt-get update \
 && apt-get install -y wget unzip curl php-fpm php-cli php-mysql php-xml php-cgi mariadb-client \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

COPY tools/entrypoint.sh /usr/local/bin/wordpress-entrypoint.sh

WORKDIR /var/www/html

RUN wget -q https://wordpress.org/latest.tar.gz \
 && tar xzf latest.tar.gz --strip-components=1 \
 && rm latest.tar.gz

RUN mkdir -p /run/php \
 && chmod +x /usr/local/bin/wordpress-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]