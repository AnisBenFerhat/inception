FROM 		debian:bookworm

LABEL		maintainer="aben-fer@42.fr" \
			version="1.0" \
			description="Container monitoring service"

RUN			apt-get update && apt-get install -y --no-install-recommends \
			wget \
			ca-certificates \
			&& rm -rf /var/lib/apt/lists/*

RUN			wget https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64 -O /usr/bin/cadvisor \
			&& chmod +x /usr/bin/cadvisor

EXPOSE		8080

CMD			["/usr/bin/cadvisor", "-logtostderr"]
