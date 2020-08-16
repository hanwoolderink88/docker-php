FROM php:7.4.9-apache-buster
RUN apt-get update
RUN a2enmod rewrite && a2enmod headers

#install libs and php libs
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libicu-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y libonig-dev
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install opcache
RUN docker-php-ext-install intl
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN pecl install APCu
RUN docker-php-ext-enable apcu
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# copy vhost config
COPY ./apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# will be overwritten on mount, but for empty projects this will do as a starting point..
RUN rm -r /var/www/html
RUN mkdir -p /var/www/project/public /var/www/var
RUN chmod -R 777 /var/www/var/
RUN echo "<?php phpinfo();" > /var/www/project/public/index.php

# set workdir
WORKDIR /var/www/project

# adding the installer to the global path
COPY ./project-install.sh /usr/local/bin/project-install
