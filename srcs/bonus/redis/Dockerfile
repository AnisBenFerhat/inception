FROM 		debian:bookworm

LABEL 		maintainer="aben-fer@42.fr" \
      		version="1.0" \
      		description="Redis cache service"

ENV			DEBIAN_FRONTEND=noninteractive

RUN			apt-get update && apt-get install -y --no-install-recommends \
			redis-server \
			&& rm -rf /var/lib/apt/lists/*

COPY		conf/redis.conf /etc/redis/redis.conf

EXPOSE		6379

CMD		["redis-server","/etc/redis/redis.conf"]
