FROM php:7.1-fpm-alpine3.9
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.42
ENV PKG_VER=1-42

# Installed required dependencies
RUN apk add --no-cache --update \
        unzip bash wget caddy supervisor openldap-dev libpng-dev freetype libjpeg-turbo-dev

# Install php modules
RUN docker-php-ext-install -j$(nproc) mysqli ldap pdo pdo_mysql iconv \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd

# Copy caddy config
COPY Caddyfile /etc/Caddyfile
# Copy supervisord config
COPY supervisord.conf /etc/supervisord.conf
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

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
