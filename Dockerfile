FROM alpine:3.22.0
COPY entrypoint.sh entrypoint.sh
COPY templates/unbound.template /tmp/unbound.template
COPY loki /etc/loki
RUN apk update && \
    apk upgrade && \
    apk add --no-cache unbound=1.23.0 && \
    apk add --no-cache gettext=0.24.1-r0 && \
    apk add --no-cache bash=5.2.37-r0 && \
    mkdir -p /var/lib/unbound && \
    wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && \
    mkdir -p /var/log/unbound && \
    chown unbound:unbound /var/log/unbound && \ 
    chmod 777 /var/log/unbound && \
    echo "0       0       1       *       *       curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && pkill unbound && unbound >> /var/log/unbound/restart.log 2>&1" >> /etc/crontabs/root && \
    apk add --no-cache loki=3.5.1-r0 && \
    apk add --no-cache loki-promtail=3.5.1-r0 && \
    chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
