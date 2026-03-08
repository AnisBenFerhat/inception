#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "First run detected: init of MariaDB tables..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null


	echo "Starting MariaDB daemon in the background to apply SQL Setup..."
	mysqld_safe --datadir=/var/lib/mysql &
	MARIADB_PID=$!

	trap "kill -15 $MARIADB_PID 2>/dev/null || true" EXIT



	until mariadb-admin ping --silent; do
		echo "waiting for MariaDB daemon to start..."
		sleep 1
	done

	echo "Applying security and Database setup..."
	mariadb -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "Shutting down MariaDB background process..."
	mariadb-admin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

	wait $MARIADB_PID

	trap - EXIT
else
	echo "Tables already exist. Skipping init."
fi


echo "Setup complete. MariadB becomes PID 1"
exec mysqld_safe --datadir=/var/lib/mysql
