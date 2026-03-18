FROM 		debian:bookworm

LABEL 		maintainer="aben-fer@42.fr" \
			version="1.0" \
			description="Static website service"

RUN			apt-get update && apt-get install -y --no-install-recommends\
			nginx \
			&& rm -rf /var/lib/apt/lists/*

COPY		conf/nginx.conf /etc/nginx/nginx.conf
COPY		tools/index.html /var/www/inception/index.html
COPY		tools/style.css /var/www/inception/style.css

RUN			chown -R www-data:www-data /var/www/inception

EXPOSE 		8080

CMD			["nginx", "-g", "daemon off;"]
