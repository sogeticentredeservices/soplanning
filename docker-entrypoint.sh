#!/usr/bin/env sh

set -e

if [ "$1" == "/usr/bin/supervisord" ]; then
    if [ ! -e index.php ]; then
        echo >&2 "SoPlanning not found in $PWD - copying now..."
        cp -r /usr/src/soplanning/* /var/www/html/
        echo >&2 "Complete! SoPlanning has been successfully copied to $PWD"

        echo >&2 "Cleaning old configuration files..."
        rm /var/www/html/{config,database}.inc
        if [ ! -e "/var/www/html/database.inc" ] && [ ! -e "/var/www/html/config.inc" ]; then
            echo >&2 "Generating new configuration files..."
            if [ -n "${SSO_PORTAL+x}"]; then
                sed -e "s#{{SSO_PORTAL}}#${SSO_PORTAL:-https://portal.example.com}#g" \
                    /usr/src/config.inc.template > /var/www/config.inc
            fi
            if [ -n "${MYSQL_DATABASE+x}" ] && [ -n "${MYSQL_USER+x}" ] && [ -n "${MYSQL_PASSWORD+x}" ] && [ -n "${MYSQL_HOST+x}" ]; then
                sed -e "s#{{MYSQL_DATABASE}}#${MYSQL_DATABASE}#g" \
                    -e "s#{{MYSQL_USER}}#${MYSQL_USER}#g" \
                    -e "s#{{MYSQL_PASSWORD}}#${MYSQL_PASSWORD}#g" \
                    -e "s#{{MYSQL_HOST}}#${MYSQL_HOST}#g" \
                    /usr/src/database.inc.template > /var/www/database.inc
            fi
        fi

        echo >&2 "fixing ownership..."
        chmod -R 755 /var/www/html
        chown -R www-data:www-data /var/www/html
        echo >&2 "...done"
        echo >&2 "Complete! SoPlanning is ready to use!"
    fi
fi

exec "$@"
