# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:19 by maroy             #+#    #+#              #
#    Updated: 2024/10/26 17:25:57 by maroy            ###   ########.qc        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_root_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_password)

# Download and set up WP-CLI
echo "Setting up WP-CLI..."
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Ensure PHP run directory exists
mkdir -p /run/php

# Check if WordPress is installed
rm -rf /var/www/html/*
if [ ! -f wp-config.php ]; then
    echo "WordPress not installed. Installing..."

    # Download WordPress core files if not already present
    if [ ! -f wp-includes/version.php ]; then
        echo "Downloading WordPress core files..."
        wp core download --allow-root
    else
        echo "WordPress core files already present."
    fi

    # Create WordPress configuration file
    echo "Configuring WordPress..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
		--dbcharset="utf8" \
        --dbcollate="utf8_general_ci" \
        --path="/var/www/html" \
        --allow-root

    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--path="/var/www/html" \
        --allow-root

    # Create a new user
    echo "Creating WordPress user..."
    # Check if the user already exists
    if wp user get "$WP_USER_USER" --field=user_login --allow-root > /dev/null 2>&1; then
        echo "User '$WP_USER_USER' already exists."
    else
    # Create the user if it does not exist
    wp user create \
        "$WP_USER_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
    echo "User '$WP_USER_USER' created."
    fi
    echo "Displaying users..."
	wp user list --allow-root
else
    echo "WordPress already installed."
fi
echo "Wordpress listening on port 9000"

# Adjust PHP-FPM configuration for socket connection
echo "Configuring PHP-FPM..."
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# Complete setup and start PHP-FPM
echo "WordPress initialization complete."
exec php-fpm7.4 -F
