# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:30 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 15:20:31 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    mariadb-server \
    && apt-get clean autoclean && \
    apt-get autoremove --yes

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./tools/health_check.sh /usr/local/bin/health_check.sh

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/health_check.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]