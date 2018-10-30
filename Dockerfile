FROM php:7.1-fpm-alpine3.8
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.42
ENV PKG_VER=1-42

# Installed required dependencies
RUN apk add --no-cache --update \
        unzip caddy supervisor openldap-dev

# Install php modules
RUN docker-php-ext-install mysqli ldap

# Copy caddy config
COPY Caddyfile /etc/Caddyfile
# Copy supervisord config
COPY supervisord.conf /etc/supervisord.conf
# Copy docker entrypoint
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

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
