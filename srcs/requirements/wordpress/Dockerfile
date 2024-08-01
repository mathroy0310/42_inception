# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:23 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 15:20:24 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
	&& apt-get clean autoclean && \
    apt-get autoremove --yes

# Set the working directory for WordPress
WORKDIR /var/www/html

RUN ["chmod", "+x", "/usr/bin/php"]

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]