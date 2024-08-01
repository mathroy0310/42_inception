FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-client \
    curl \
    wget \
    php \
    php-fpm \
    php-mysql \
    php-cli \
    php-cgi \
    php-pdo \
    php-mbstring \
	&& apt-get clean

# Set the working directory for WordPress
WORKDIR /var/www/html

RUN ["chmod", "+x", "/usr/bin/php"]

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]