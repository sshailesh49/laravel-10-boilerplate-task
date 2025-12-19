FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    wget \
    curl \
    git \
    grep \
    build-base \
    libmemcached-dev \
    libxml2-dev \
    imagemagick-dev \
    pcre-dev \
    libtool \
    autoconf \
    g++ \
    cyrus-sasl-dev \
    libgsasl-dev \
    supervisor

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql xml

# Install PECL extensions
RUN pecl channel-update pecl.php.net \
    && pecl install memcached imagick \
    && docker-php-ext-enable memcached imagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www

# Supervisor config
COPY ./dev/docker-compose/php/supervisord-app.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
