# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    add_hosts.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/02 20:13:21 by maroy             #+#    #+#              #
#    Updated: 2024/08/02 20:17:19 by maroy            ###   ########.qc        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set -e

DOMAIN_NAME="maroy.42.qc"
DOMAIN_NAME_WWW="www.${DOMAIN_NAME}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 0
fi
if awk -v VAR=${DOMAIN_NAME} 'BEGIN {result = 0} $2 == VAR {result = 1; exit} END {exit result}' /etc/hosts; then
	echo "${DOMAIN_NAME} is missing from /etc/hosts"
	echo "Adding ${DOMAIN_NAME} to /etc/hosts."
	echo "127.0.0.1	${DOMAIN_NAME}" >> /etc/hosts
fi

if awk -v VAR=${DOMAIN_NAME_WWW} 'BEGIN {result = 0} $2 == VAR {result = 1; exit} END {exit result}' /etc/hosts; then
	echo "${DOMAIN_NAME_WWW} is missing from /etc/hosts"
	echo "Adding ${DOMAIN_NAME_WWW} to /etc/hosts."
	echo "127.0.0.1	${DOMAIN_NAME_WWW}" >> /etc/hosts
fi