FROM php:5-fpm-alpine3.8
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV PKG_BASEVER=v1.42
ENV PKG_VER=1-42

# Installed required dependencies
RUN apk add --no-cache --update \
        unzip

# Working directory
WORKDIR /var/www/html

# Get latest soplanning release
RUN wget -O "soplanning-$PKG_VER.zip" "https://sourceforge.net/projects/soplanning/files/soplanning/$PKG_BASEVER/soplanning-$PKG_VER.zip/download" \
    && mkdir -p /usr/src/soplanning \
    && unzip "soplanning-$PKG_VER.zip" -d /usr/src \
    && rm "soplanning-$PKG_VER.zip"

EXPOSE 9000

CMD ["php-fpm"]
