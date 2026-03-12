#!/bin/bash
set -e

chown -R www-data:www-data /var/www/html

until mariadb-admin ping -h mariadb --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress not found. Starting installation..."
	cd /var/www/html
	wp core download --version=6.4.3 --allow-root
	wp config create \
		--dbname="${SQL_DATABASE}" \
		--dbuser="${SQL_USER}" \
		--dbpass="${SQL_PASSWORD}" \
		--dbhost=mariadb \
		--allow-root
	wp core install \
		--url="${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--allow-root
	wp user create \
		"${WP_USER}" "${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}" \
		--allow-root

	wp plugin install redis-cache --activate --allow-root
	wp config set WP_REDIS_HOST 'redis' --allow-root
	wp config set WP_REDIS_PORT 6379 --raw --allow-root
	wp redis enable --allow-root

	echo "WordPress installation successful."
else
	echo "WordPress is already configured. Skipping install."
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
