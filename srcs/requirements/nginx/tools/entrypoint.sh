#!/bin/sh

# Check if SSL files exist, if not, create them
if [ ! -f /etc/nginx/ssl/bundle.crt ] || [ ! -f /etc/nginx/ssl/private.key ]; then
    echo "SSL files not found, creating them..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/private.key -out /etc/nginx/ssl/bundle.crt -subj "/CN=localhost"
fi

# Start nginx
nginx -g 'daemon off;'
echo "Nginx started."