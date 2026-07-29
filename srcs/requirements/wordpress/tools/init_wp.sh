#!/bin/bash
set -e

cd /var/www/html

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

