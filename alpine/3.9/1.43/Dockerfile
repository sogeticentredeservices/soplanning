FROM php:7.2-fpm-alpine3.9
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.43
ENV PKG_VER=1-43
ENV SOPLANNING_DOWNLOAD_SHA256=f96143d476f7348f7dd0fb35fa504b6f21970e2aa929c4849f5a8f1d88b075aa

# Installed required dependencies
RUN apk add --no-cache --update \
        bash \
        caddy \
        curl \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        openldap-dev \
        su-exec \
        supervisor \
        unzip

# Install php modules
RUN docker-php-ext-install -j$(nproc) iconv ldap mysqli pdo pdo_mysql \
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
RUN curl -fSL -o \
        "soplanning.zip" \
        "https://sourceforge.net/projects/soplanning/files/soplanning/$PKG_BASEVER/soplanning-$PKG_VER.zip/download" \
    && echo "$SOPLANNING_DOWNLOAD_SHA256 *soplanning.zip" | sha256sum -c - \
    && mkdir -p /usr/src/soplanning \
    && unzip "soplanning.zip" -d /usr/src \
    && rm "soplanning.zip"

RUN adduser -D www-data

USER www-data

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
