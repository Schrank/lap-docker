FROM php:7.0-fpm
RUN apt-get update && apt-get install -y \
  libcurl4-openssl-dev \
  libxml2-dev \
  libmcrypt-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng12-dev \
  libicu-dev \
    && docker-php-ext-install -j$(nproc) intl  \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
