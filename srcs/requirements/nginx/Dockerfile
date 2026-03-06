FROM 		debian:bookworm

LABEL 		maintainer="aben-fer@42.fr" \
			version="1.0" \
			description="NGINX with TLS 1.2/1.3"

ENV DEBIAN_FRONTEND=noninteractive

RUN 		apt-get update && apt-get install -y --no-install-recommends \
			nginx \
			openssl \
			&& rm -rf /var/lib/apt/lists/*

COPY 		conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY 		tools/setup.sh /usr/local/bin/setup.sh

RUN 		chmod +x /usr/local/bin/setup.sh

RUN 		mkdir -p /var/www/html && \
			chown -R www-data:www-data /var/www/html

EXPOSE 443

ENTRYPOINT 	["/usr/local/bin/setup.sh"]

CMD 		["nginx", "-g", "daemon off;"]
