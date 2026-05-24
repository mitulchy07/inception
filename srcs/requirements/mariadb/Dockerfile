FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y mariadb-server \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
