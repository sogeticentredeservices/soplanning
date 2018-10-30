#!/usr/bin/env sh

if [ "$1" == "php-fpm" ]; then
    if [ ! -e index.php ] && [ ! -e config.inc ]; then
        echo >&2 "SoPlanning not found in $PWD - copying now..."
        cp -r /usr/src/soplanning/* /var/www/html
        echo >&2 "Complete! SoPlanning has been successfully copied to $PWD"
        if [ ! -e "/var/www/html/database.inc" ] && [ ! -e "/var/www/html/config.inc" ]; then
            # Copy env variable to templates
            echo "Configuration files not found."
            echo "Generating configuration files..."
        fi
    fi
fi

exec "$@"
