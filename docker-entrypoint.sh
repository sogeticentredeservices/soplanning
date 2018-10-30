#!/usr/bin/env sh

if [ "$1" == "/usr/bin/supervisord" ]; then
    if [ ! -e index.php ] && [ ! -e config.inc ]; then
        echo >&2 "SoPlanning not found in $PWD - copying now..."
        cp -r /usr/src/soplanning/* /var/www/html/
        echo >&2 "Complete! SoPlanning has been successfully copied to $PWD"
        if [ ! -e "/var/www/html/database.inc" ] && [ ! -e "/var/www/html/config.inc" ]; then
            # Copy env variable to templates
            echo "Configuration files not found."
            echo "Generating configuration files..."
            chmod -R 755 /var/www/html
            chown -R www-data:www-data /var/www/html
        fi
    fi
fi

exec "$@"
