# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    add_hosts.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/02 20:13:21 by maroy             #+#    #+#              #
#    Updated: 2024/08/15 15:49:07 by maroy            ###   ########.qc        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set -e

DOMAIN_NAME="maroy.42.qc"
DOMAIN_NAME_WWW="www.${DOMAIN_NAME}"
IP_ADDRESS="127.0.0.1"

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 0
fi

# Function to add domain to /etc/hosts
add_domain_to_hosts() {
    local domain=$1
    local ip=$2
    if ! grep -q "$domain" /etc/hosts; then
        echo "Adding $domain to /etc/hosts"
        echo "$ip $domain" | sudo tee -a /etc/hosts > /dev/null
    else
        echo "$domain already exists in /etc/hosts"
    fi
}

# Add both domains to /etc/hosts
add_domain_to_hosts "$DOMAIN_NAME" "$IP_ADDRESS"
add_domain_to_hosts "$DOMAIN_NAME_WWW" "$IP_ADDRESS"

# Flush DNS cache using systemd-resolved if available
if systemctl is-active --quiet systemd-resolved; then
    sudo systemctl restart systemd-resolved
fi