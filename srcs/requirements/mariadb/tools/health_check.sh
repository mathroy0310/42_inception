# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    health_check.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:32 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 15:20:33 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
# Script to check if the database file was created
if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]; then
    exit 1
else
    exit 0
fi