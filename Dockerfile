FROM debian:buster-slim

# set locale
RUN apt-get update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependancies
RUN apt-get update && apt-get install -y \
    zip wget curl unzip nano git php-pear \
    zlib1g-dev libicu-dev libc-dev \
    libpq-dev libxml2-dev gcc \
    make autoconf pkg-config > /dev/null

# install apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_SERVER_NAME localhost

RUN apt-get update \
    && apt-get install -y apache2 > /dev/null

EXPOSE 80

RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-pgsql \
    php7.3-phpdbg \
    php7.3-soap \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
    php7.3-dev \
    php-xdebug > /dev/null

#apcu
RUN pecl install apcu
RUN echo "extension = apcu.so" > /etc/php/7.3/apache2/conf.d/apcu.ini
RUN echo "extension = apcu.so" > /etc/php/7.3/cli/conf.d/apcu.ini

#xdebug config
COPY ./php/xdebug.ini /etc/php/7.3/apache2/conf.d/docker-php-ext-xdebug.ini
COPY ./php/xdebug.ini /etc/php/7.3/cli/conf.d/docker-php-ext-xdebug.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# install symfony installer
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

#vhost
COPY ./apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# will be overwritten on mount, but for empty projects this will do as a starting point..
RUN rm -r /var/www/html
RUN mkdir -p /var/www/project/public /var/www/var
RUN chmod -R 777 /var/www/var/
RUN echo "<?php phpinfo();" > /var/www/project/public/index.php

# have to restart to sync in php
RUN service apache2 restart

WORKDIR /var/www/project

#config git to some global sjeit
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

# adding the installer to the global path
COPY ./project-install.sh /usr/local/bin/project-install

# Launch Apache
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]