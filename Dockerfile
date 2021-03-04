FROM php:7.4-fpm

COPY config/custom.ini /usr/local/etc/php/conf.d/

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev libpq-dev wget git libmemcached-dev \
    && docker-php-ext-install opcache \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install zip

ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_PHPLIST /usr/local/bin

WORKDIR /var/www/html

RUN usermod -u 1000 www-data