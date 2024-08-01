#!/bin/bash
set -e

# Create /run/mysqld directory if it doesn't exist
if [ ! -d /run/mysqld ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Initialize MySQL data directory if it doesn't exist
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MySQL data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
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
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
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
exec mysqld --datadir=/var/lib/mysql
