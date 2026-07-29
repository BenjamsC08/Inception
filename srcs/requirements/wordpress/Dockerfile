FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-intl \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*


RUN curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "listen = 9000" > /etc/php/8.2/fpm/pool.d/zz-listen.conf

RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

COPY tools/init_wp.sh /init_wp.sh

RUN chmod +x /init_wp.sh
EXPOSE 9000

ENTRYPOINT ["/init_wp.sh"]
