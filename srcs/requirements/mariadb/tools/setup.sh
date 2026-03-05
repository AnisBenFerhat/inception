#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "First run detected: init of MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "Starting MariaDB daemon in the background..."
mysqld_safe --datadir=/var/lib/mysql &



until mariadb-admin ping --silent; do
	echo "waiting for MariaDB daemon to start..."
	sleep 1
done

mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

echo "Setup complete. MariadB becomes PID 1"
exec mysqld_safe --datadir=/var/lib/mysql
