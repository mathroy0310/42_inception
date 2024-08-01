# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/01 15:20:35 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 15:20:36 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
set -e

echo "Creating /etc/mysql/mariadb.conf.d/50-server.cnf..."
cat > /etc/mysql/mariadb.conf.d/50-server.cnf <<EOF
[mysqld]
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
lc-messages             = en_US
bind-address            = 0.0.0.0
expire_logs_days        = 10
character-set-server    = utf8mb4
collation-server        = utf8mb4_general_ci
EOF

# Create /run/mysqld directory if it doesn't exist
if [ ! -d /run/mysqld ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Initialize MySQL data directory if it doesn't exist
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MySQL data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm --skip-test-db > /dev/null
fi

# Start MySQL safely in the background
echo "Starting MySQL..."
mysqld --datadir=/var/lib/mysql &

# Wait for MySQL to start (optional but recommended)
while ! mysqladmin ping --silent; do
    sleep 1
done

echo "Creating database and user..."
cat <<EOF | mysql -u root -h localhost
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Kill any existing mysqld processes
if pgrep -x "mysqld" > /dev/null; then
    echo "Stopping existing mysqld process..."
    pkill -x mysqld
fi

# Keep MySQL running in the foreground
echo "MySQL setup complete. Keeping MySQL running..."
echo "MariaDB listening on port 3306"
exec mysqld --datadir=/var/lib/mysql
