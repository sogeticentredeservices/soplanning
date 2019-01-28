FROM php:7.2-apache
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.43
ENV PKG_VER=1-43
ENV APACHE_DOCUMENT_ROOT /var/www/html/www

# Installed required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip bash wget libldap-dev libpng-dev

# Install php modules
RUN docker-php-ext-install mysqli ldap gd pdo pdo_mysql

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
