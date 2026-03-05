FROM 			debian:bookworm

LABEL 			maintainer="aben-fer@42.fr" \
				version="1.0" \
				description="MariaDB Server Database"

ENV 			DEBIAN_FRONTEND=noninteractive

RUN 			apt-get update && apt-get install -y --no-install-recommends \
				mariadb-server \
				mariadb-client \
				&& rm -rf /var/lib/apt/lists/*

RUN 			mkdir -p /run/mysqld && \
				chown -R mysql:mysql /run/mysqld && \
				chmod 775 /run/mysqld

COPY			conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY			tools/setup.sh /usr/local/bin/setup.sh
RUN				chmod +x /usr/local/bin/setup.sh

VOLUME 			["/var/lib/mysql"]

EXPOSE 			3306

HEALTHCHECK 	--interval=30s --timeout=10s --retries=3 \
	CMD			mariadb-admin ping -h localhost --silent || exit 1

ENTRYPOINT		["/usr/local/bin/setup.sh"]
