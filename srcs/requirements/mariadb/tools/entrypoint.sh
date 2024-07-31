#!/bin/bash
set -e

#!/bin/bash
set -e

# Create /run/mysqld directory if it doesn't exist
if [ ! -d /run/mysqld ]; then
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld
fi

# Start MariaDB
exec mysqld


# Wait for MySQL to start (optional but recommended)
while ! mysqladmin ping --silent; do
    sleep 1
done

mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

