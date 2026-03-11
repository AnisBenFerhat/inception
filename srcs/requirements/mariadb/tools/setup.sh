#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "First run detected: init of MariaDB system tables..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	echo "Starting MariaDB daemon in the background to apply SQL setup..."
	mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
	MARIADB_PID=$!

	trap "kill -15 $MARIADB_PID 2>/dev/null || true" EXIT

	until mariadb-admin ping --silent; do
		echo "Waiting for MariaDB daemon to start..."
		sleep 1
	done

	echo "Applying security and database setup..."
	mariadb -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "Shutting down MariaDB background process..."
	mariadb-admin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

	wait $MARIADB_PID || true
	trap - EXIT
else
	echo "Database already exists. Skipping init."
fi

echo "Setup complete. MariaDB becomes PID 1"
exec mariadbd --user=mysql --datadir=/var/lib/mysql
