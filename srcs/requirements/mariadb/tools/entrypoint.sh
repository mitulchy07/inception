#!/bin/sh

set -eu

: "${MYSQL_ROOT_PASSWORD_FILE:?MYSQL_ROOT_PASSWORD_FILE is required}"
: "${MYSQL_PASSWORD_FILE:?MYSQL_PASSWORD_FILE is required}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"

escape_sql() {
	printf '%s' "$1" | sed "s/\\\\/\\\\\\\\/g; s/'/''/g"
}

root_password=$(tail -n 1 "$MYSQL_ROOT_PASSWORD_FILE" | tr -d '\r')
user_password=$(tail -n 1 "$MYSQL_PASSWORD_FILE" | tr -d '\r')
root_password_sql=$(escape_sql "$root_password")
user_password_sql=$(escape_sql "$user_password")

mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

fresh_install=false
if [ ! -d /var/lib/mysql/mysql ]; then
	fresh_install=true
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db --auth-root-authentication-method=normal >/dev/null
fi

mariadbd --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0 --port=3306 &
server_pid=$!

until mysqladmin -u root -P 3306 --protocol=socket --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
	sleep 1
done

if mariadb --protocol=socket --socket=/run/mysqld/mysqld.sock -uroot -e 'SELECT 1' >/dev/null 2>&1; then
	root_client_args="--protocol=socket --socket=/run/mysqld/mysqld.sock -uroot"
else
	root_client_args="--protocol=socket --socket=/run/mysqld/mysqld.sock -uroot --password=$root_password"
fi

mariadb $root_client_args <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password_sql}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${user_password_sql}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mysqladmin --protocol=socket --socket=/run/mysqld/mysqld.sock -uroot --password="$root_password" -P 3306 shutdown
wait "$server_pid" || true

exec mariadbd --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0 --port=3306