#!/usr/bin/env bash

set -e

if [ "$1" == "/usr/bin/supervisord" ]; then
    if [ ! -e index.php ]; then
        echo >&2 "SoPlanning not found in $PWD - copying now..."
        cp -r /usr/src/soplanning/* /var/www/html/
        echo >&2 "... SoPlanning has been successfully copied to $PWD"

        echo >&2 "Cleaning old configuration files..."
        rm /var/www/html/{config,database}.inc
        if [ ! -e "/var/www/html/database.inc" ] && [ ! -e "/var/www/html/config.inc" ]; then
            echo >&2 "Generating new configuration files..."
            if [ -n "${SSO_PORTAL_URL}" ]; then
                sed -e "s#{{SSO_PORTAL_URL}}#${SSO_PORTAL_URL:-https://portal.example.com}#g" \
                    /usr/src/config.inc.template > /var/www/html/config.inc
            else
                echo >&2 "Missing environment variables!: SSO_PORTAL_URL"
            fi
            if [ -n "${MYSQL_DATABASE}" ] && [ -n "${MYSQL_USER}" ] && [ -n "${MYSQL_PASSWORD}" ] && [ -n "${MYSQL_HOST}" ]; then
                sed -e "s#{{MYSQL_HOST}}#${MYSQL_HOST:-localhost}#g" \
                    -e "s#{{MYSQL_DATABASE}}#${MYSQL_DATABASE:-soplanning}#g" \
                    -e "s#{{MYSQL_USER}}#${MYSQL_USER}#g" \
                    -e "s#{{MYSQL_PASSWORD}}#${MYSQL_PASSWORD}#g" \
                    /usr/src/database.inc.template > /var/www/html/database.inc
            else
                echo >&2 "Missing environment variables!: MYSQL_HOST, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD"
            fi
            echo >&2 "...New configuration files generated"
        fi

        echo >&2 "Fixing files ownership..."
        chmod -R 755 /var/www/html
        chown -R www-data:www-data /var/www/html
        echo >&2 "...done"

        echo >&2 "Complete! SoPlanning is ready to use!"
    fi
fi

exec gosu www-data "$@"
