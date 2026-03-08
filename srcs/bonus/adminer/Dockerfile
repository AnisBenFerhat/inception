FROM 		debian:bookworm

LABEL 		maintainer="aben-fer@42.fr" \
      		version="1.0" \
      		description="Adminer Database Management Tool"

ENV			DEBIAN_FRONTEND=noninteractive

RUN 		apt-get update && apt-get install -y --no-install-recommends \
			php8.2 \
			php8.2-mysql \
			wget \
			ca-certificates \
			&& rm -rf /var/lib/apt/lists/*

RUN 		mkdir -p /var/www/html

RUN 		wget -q -O /var/www/html/index.php "https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-mysql-en.php"

RUN			chown -R www-data:www-data /var/www/html && \
			chmod 755 /var/www/html

WORKDIR		/var/www/html

EXPOSE 		8080

ENTRYPOINT	["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
