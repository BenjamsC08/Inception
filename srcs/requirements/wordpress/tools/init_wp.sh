#!/bin/bash
set -eu
# -u : stop if variable not defined
# -e : stop if command failed

if [ ! -f /run/secrets/db_user_password ]; then
  echo "secret db_user_password not found" >&2
  exit 1
fi

if [ ! -f /run/secrets/wp_admin_password ]; then
  echo "secret wp_admin_password not found" >&2
  exit 1
fi

if [ ! -f /run/secrets/wp_user_password ]; then
  echo "secret wp_user_password not found" >&2
  exit 1
fi

WORDPRESS_DB_PASSWORD="$(cat /run/secrets/db_user_password)"
WORDPRESS_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"
WORDPRESS_USER_PASSWORD="$(cat /run/secrets/wp_user_password)"

until mysqladmin ping -h"${WORDPRESS_DB_HOST%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
	echo "waiting for mariadb..."
	sleep 2
done

if [ ! -f wp-config.php ]; then
	wp core download --allow-root

	wp config create \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--allow-root

	wp core install \
		--url="https://${DOMAIN_NAME}"\
		--title="Inception" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--skip-email \
		--allow-root

	wp user create \
		"${WORDPRESS_USER}" \
		"${WORDPRESS_USER_EMAIL}" \
		--user_pass="${WORDPRESS_USER_PASSWORD}" \
		--role=author \
		--allow-root
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F

