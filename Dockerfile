FROM alpine:3.22.0
COPY entrypoint.sh entrypoint.sh
COPY templates/unbound.template /tmp/unbound.template
RUN apk update && \
    apk upgrade && \
    apk add --no-cache unbound && \
    apk add --no-cache gettext && \
    apk add --no-cache bash && \
    mkdir -p /var/lib/unbound && \
    wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && \
    mkdir -p /var/log/unbound && \
    echo "0       0       1       *       *       curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && pkill unbound && unbound >> /var/log/unbound/restart.log 2>&1" >> /etc/crontabs/root && \
    chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
