FROM php:7.1-apache
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.42
ENV PKG_VER=1-42
ENV APACHE_DOCUMENT_ROOT /var/www/html/www

# Installed required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip bash wget libldap-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev

# Install php modules
RUN docker-php-ext-install -j$(nproc) mysqli ldap pdo pdo_mysql iconv \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd

# Copy docker entrypoint
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
# Copy template files
COPY database.inc.template /usr/src/
COPY config.inc.template /usr/src/

# Working directory
WORKDIR /var/www/html

# Get latest soplanning release
RUN wget -O \
        "soplanning-$PKG_VER.zip" \
        "https://sourceforge.net/projects/soplanning/files/soplanning/$PKG_BASEVER/soplanning-$PKG_VER.zip/download" \
    && mkdir -p /usr/src/soplanning \
    && unzip "soplanning-$PKG_VER.zip" -d /usr/src \
    && rm "soplanning-$PKG_VER.zip"

# Change apache root directory
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
