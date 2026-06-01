#!/bin/sh

set -eu

if [ -n "${WORDPRESS_CREDENTIALS_FILE:-}" ] && [ -f "$WORDPRESS_CREDENTIALS_FILE" ]; then
	. "$WORDPRESS_CREDENTIALS_FILE"
fi

require_var() {
	variable_name=$1
	eval "variable_value=\${$variable_name:-}"
	if [ -z "$variable_value" ]; then
		echo "$variable_name is required" >&2
		exit 1
	fi
}

for variable_name in DOMAIN_NAME WORDPRESS_DB_HOST WORDPRESS_DB_NAME WORDPRESS_DB_USER WORDPRESS_DB_PASSWORD_FILE WP_TITLE WP_ADMIN_USER WP_ADMIN_EMAIL WP_ADMIN_PASSWORD WP_USER WP_USER_EMAIL WP_USER_PASSWORD; do
	require_var "$variable_name"
done

db_password=$(tail -n 1 "$WORDPRESS_DB_PASSWORD_FILE" | tr -d '\r')

if [ ! -f /var/www/html/index.php ]; then
	cp -R /usr/src/wordpress/. /var/www/html/
fi

mkdir -p /run/php
chown -R www-data:www-data /var/www/html /run/php

until mysqladmin --host="$WORDPRESS_DB_HOST" --user="$WORDPRESS_DB_USER" --password="$db_password" ping >/dev/null 2>&1; do
	sleep 1
done

wp core config --allow-root \
	--path=/var/www/html \
	--dbname="$WORDPRESS_DB_NAME" \
	--dbuser="$WORDPRESS_DB_USER" \
	--dbpass="$db_password" \
	--dbhost="$WORDPRESS_DB_HOST:3306" \
	--skip-check \
	--force

if ! wp core is-installed --allow-root --path=/var/www/html >/dev/null 2>&1; then
	wp core install --allow-root \
		--path=/var/www/html \
		--url="https://${DOMAIN_NAME}" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"

	if ! wp user get "$WP_USER" --allow-root --path=/var/www/html >/dev/null 2>&1; then
		wp user create --allow-root \
			--path=/var/www/html \
			"$WP_USER" "$WP_USER_EMAIL" \
			--role=subscriber \
			--user_pass="$WP_USER_PASSWORD"
	fi
fi

wp option update home --allow-root --path=/var/www/html "https://${DOMAIN_NAME}" >/dev/null
wp option update siteurl --allow-root --path=/var/www/html "https://${DOMAIN_NAME}" >/dev/null

exec "$@"