# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:28 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 15:20:29 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh
set -e

# Check if SSL files exist, if not, create them
if [ ! -f ${SSL_CERTIFICATE} ] || [ ! -f ${SSL_CERTIFICATE_KEY} ]; then
    echo "SSL files not found, creating them..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${SSL_CERTIFICATE_KEY} -out ${SSL_CERTIFICATE} -subj "/CN=localhost"
fi

cat > /etc/nginx/conf.d/default.conf << EOF
server {
	listen 443 ssl;
	listen [::]:443 ssl;

	server_name $DOMAIN_NAME;  

	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_certificate $SSL_CERTIFICATE;
	ssl_certificate_key $SSL_CERTIFICATE_KEY;

	root /var/www/html;
	index index.php;

	location / {
		autoindex on;
		try_files \$uri \$uri/ /index.php\$is_args\$args;
	}

	if (\$scheme != https) {
		return 301 https://\$server_name\$request_uri;
	}

	location ~ \.php$ {
		fastcgi_pass wordpress_service:9000;
		include snippets/fastcgi-php.conf;
	}
}
EOF

# Start nginx
echo "Nginx started."
nginx -g 'daemon off;'