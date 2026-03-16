FROM		debian:bookworm

LABEL		maintainer="aben-fer@42.fr" \
			version="1.0" \
			description="FTP service"

ENV			DEBIAN_FRONTEND=noninteractive

RUN			apt-get update && apt-get install -y --no-install-recommends \
			vsftpd \
			&& rm -rf /var/lib/apt/lists/*

COPY		conf/vsftpd.conf /etc/vsftpd.conf
COPY		tools/setup.sh	/usr/local/bin/setup.sh

RUN			chmod +x /usr/local/bin/setup.sh

EXPOSE		21 40000-40005

CMD			["/usr/local/bin/setup.sh"]
