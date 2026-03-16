#!/bin/bash
set -e

if ! id "${FTP_USER}" >/dev/null 2>&1; then
	useradd -m -s /bin/bash "${FTP_USER}"
	echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
	usermod -aG www-data "${FTP_USER}"
fi

mkdir -p /var/run/vsftpd/empty

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

echo "FTP Server is starting on port 21..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
