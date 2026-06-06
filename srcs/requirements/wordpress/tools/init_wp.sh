#!/bin/bash
set -e

# Attendre que MariaDB soit prêt (optionnel mais recommandé)
sleep 5

# Télécharger WordPress si pas déjà présent
if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root

    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root
fi

# Lancer php-fpm en foreground
exec php-fpm7.4 -F
