FROM php:7.2-apache
LABEL maintainer Cedric Bonhomme, cedric.bonhomme@sogeti.com

ENV APACHE_DOCUMENT_ROOT=/var/www/html/www
ENV PKG_BASEVER=v1.44
ENV PKG_VER=1-44
ENV SOPLANNING_DOWNLOAD_SHA256=6f0df37b3493f418cecc89336f68eaf13297a7b2f4665c2875c0de6049bdde76

# Installed required dependencies
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    bash \
    curl \
    gettext-base \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libldap-dev \
    libldap-dev \
    libpng-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install php modules
RUN docker-php-ext-install -j$(nproc) iconv mysqli pdo pdo_mysql \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
        && docker-php-ext-install -j$(nproc) gd ldap

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

# Change apache root directory
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
