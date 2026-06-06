#!/bin/bash
set -e

# Générer un certificat auto-signé si pas présent
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

# Lancer nginx en foreground
exec nginx -g "daemon off;"
