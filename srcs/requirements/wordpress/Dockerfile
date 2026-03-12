FROM 			debian:bookworm

LABEL 			maintainer="aben-fer@42.fr" \
				version="1.0" \
				description="WordPress with PHP-FPM 8.2"

ENV 			DEBIAN_FRONTEND=noninteractive

RUN 			apt-get update && apt-get install -y --no-install-recommends \
				php8.2-fpm \
				php8.2-mysql \
				php8.2-redis \
				mariadb-client \
				wget \
				ca-certificates \
				netcat-openbsd \
				&& rm -rf /var/lib/apt/lists/*

RUN 			wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    			chmod +x /usr/local/bin/wp

RUN				mkdir -p /run/php /var/www/html && \
				chown -R www-data:www-data /run/php /var/www/html && \
				chmod 755 /var/www/html

COPY			conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY			tools/setup.sh /usr/local/bin/setup.sh
RUN				chmod +x /usr/local/bin/setup.sh

VOLUME 			["/var/www/html"]

EXPOSE 			9000

HEALTHCHECK 	--interval=30s --timeout=10s --retries=3 \
	CMD			nc -z localhost 9000 || exit 1

ENTRYPOINT		["/usr/local/bin/setup.sh"]
