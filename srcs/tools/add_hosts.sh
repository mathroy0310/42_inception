# **************************************************************************** #
#                                                              _               #
#                                                  __   ___.--'_\`.            #
#    add_hosts.sh                                 ( _\`.' -   'o\` )           #
#                                                 _\\.'_'      _.-'            #
#    By: mathroy0310 <maroy0310@gmail.com>       ( \`. )    //\\\`             #
#                                                 \\_'-`---'\\__,              #
#    Created: 2024/08/02 20:13:21 by maroy         \`        `-\\              #
#    Updated: 2024/08/11 19:24:01 by mathroy0310    `                          #
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

# Flush DNS cache using nscd if available
if command -v nscd > /dev/null; then
    sudo systemctl restart nscd
fi

# Flush DNS cache using dnsmasq if available
if command -v dnsmasq > /dev/null; then
    sudo systemctl restart dnsmasq
fi

# Restart Network Manager if available
if systemctl is-active --quiet NetworkManager; then
    sudo systemctl restart NetworkManager
fi

echo "DNS cache flushed and network services restarted."