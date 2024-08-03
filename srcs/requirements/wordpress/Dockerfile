# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:23 by maroy             #+#    #+#              #
#    Updated: 2024/08/02 18:36:30 by maroy            ###   ########.qc        #
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
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]