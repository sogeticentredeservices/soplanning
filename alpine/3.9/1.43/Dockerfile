FROM alpine:3.9
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.43
ENV PKG_VER=1-43
ENV SOPLANNING_DOWNLOAD_SHA256=f96143d476f7348f7dd0fb35fa504b6f21970e2aa929c4849f5a8f1d88b075aa

# Installed required dependencies
RUN apk add --no-cache --update \
        bash \
        caddy \
        curl \
        php7-fpm \
        unzip

# essential php libs
RUN apk add --no-cache \
        php7-bcmath \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fileinfo \
        php7-gd \
        php7-iconv \
        php7-json \
        php7-ldap \
        php7-mbstring \
        php7-mysqli \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pgsql \
        php7-phar \
        php7-session \
        php7-sqlite3 \
        php7-tokenizer \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zip

# symblink php7 to php
RUN ln -sf /usr/bin/php7 /usr/bin/php

# symlink php-fpm7 to php-fpm
RUN ln -sf /usr/bin/php-fpm7 /usr/bin/php-fpm

# add a php www-user instead of nobody
RUN sed -i "s|^user = .*|user = www-data|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i "s|^group = .*|group = www-data|g" /etc/php7/php-fpm.d/www.conf

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

# Copy caddy config
COPY Caddyfile /etc/Caddyfile
# Copy docker entrypoint
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
# Copy template files
COPY database.inc.template /usr/src/
COPY config.inc.template /usr/src/

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["caddy","-conf","/etc/Caddyfile"]
