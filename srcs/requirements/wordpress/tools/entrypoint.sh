#!/bin/bash
set -e

# Download and set up WP-CLI
echo "Setting up WP-CLI..."
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Ensure PHP run directory exists
mkdir -p /run/php

# Change to WordPress directory
cd /var/www/html

# Check if WordPress is installed
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
        --allow-root

    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create a new user
    echo "Creating WordPress user..."
    wp user create "$WP_USER_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PASSWORD" --allow-root

	echo "Displaying WordPress information..."
	wp db info
	wp user list


else
    echo "WordPress already installed."
fi

# Adjust PHP-FPM configuration for socket connection
echo "Configuring PHP-FPM..."
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# Complete setup and start PHP-FPM
echo "WordPress initialization complete."
exec php-fpm7.4 -F