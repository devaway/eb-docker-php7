FROM php:7.4-fpm

COPY config/custom.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y git curl bash autoconf \
        unzip vim nodejs npm gnupg \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmpc-dev
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install pdo_mysql bcmath gmp

RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN apt-get install libmcrypt-dev
RUN pecl install mcrypt && docker-php-ext-enable mcrypt

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN docker-php-ext-enable opcache

RUN npm install -g less@1.7 gulp-cli uglify-js uglifycss

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update &&  apt-get -y install yarn

RUN usermod -u 1000 www-data
