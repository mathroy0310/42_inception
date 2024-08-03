#! /bin/bash
set -e

if [ -f srcs/.env ]; then \
	echo "An .env file already exists. Do you want to overwrite it ? (y/n)"
    read -r answer
    if [ "$answer" != "y" ]; then
        exit 0
    fi
fi

echo "Generating .env file..."
echo "---------------------------------"

DOMAIN_NAME="maroy.42.qc"
MYSQL_DATABASE="inception_db"
MYSQL_HOST="mariadb_service"

WP_TITLE="Inception"

SSL_CERTIFICATE="/etc/nginx/ssl/bundle.crt"
SSL_CERTIFICATE_KEY="/etc/nginx/ssl/private.key"

VOLUMES_PATH=$HOME/data

# MySQL
read -p "Enter MySQL user (default: $USER): " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-$USER}

# WordPress
read -p "Enter WordPress admin username (default: admin): " WP_ADMIN_USER
WP_ADMIN_USER=${WP_ADMIN_USER:-admin}

read -p "Enter WordPress admin email (default: admin@student.42quebec.com): " WP_ADMIN_EMAIL
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@student.42quebec.com}

read -p "Enter WordPress user username (default: $USER): " WP_USER_USER
WP_USER_USER=${WP_USER_USER:-$USER}

read -p "Enter WordPress user email (default: $USER@student.42quebec.com): " WP_USER_EMAIL
WP_USER_EMAIL=${WP_USER_EMAIL:-$USER@student.42quebec.com}

cat <<EOF > ./srcs/.env
# Domain
DOMAIN_NAME=${DOMAIN_NAME}

# MySQL
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_HOST=${MYSQL_HOST}

# Wordpress
WP_TITLE=${WP_TITLE}
WP_ADMIN_USER=${WP_ADMIN_USER}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL}
WP_USER_USER=${WP_USER_USER}
WP_USER_EMAIL=${WP_USER_EMAIL}

# Certificates
SSL_CERTIFICATE=${SSL_CERTIFICATE}
SSL_CERTIFICATE_KEY=${SSL_CERTIFICATE_KEY}

# Volumes path
VOLUMES_PATH=${VOLUMES_PATH}
EOF

echo "---------------------------------"
echo "Success ! .env file has been created with the specified values."