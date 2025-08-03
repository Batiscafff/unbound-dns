FROM alpine:3.22.0
COPY entrypoint.sh entrypoint.sh
COPY templates/unbound.template /tmp/unbound.template
COPY loki /etc/loki
#__________________________Global_Settings__________________________
RUN apk update && \
    apk upgrade && \
    apk add --no-cache tzdata && \
#__________________________Unbound_Block__________________________
    apk add --no-cache unbound && \
    apk add --no-cache ca-certificates && \
    mkdir -p /var/lib/unbound && \
    mkdir -p /var/log/unbound && \
    wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && \
    chown unbound:unbound /var/log/unbound && \
    chown -R unbound:unbound /var/lib/unbound && \
    echo "0       0       1       *       *       curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache  && pkill unbound && unbound >> /var/log/unbound/restart.log 2>&1" >> /etc/crontabs/root && \
#__________________________Promtail_Block__________________________
    apk add --no-cache loki-promtail && \
#__________________________Loki_Block__________________________
    apk add --no-cache loki && \
#__________________________Entrypoint_Block__________________________
    apk add --no-cache gettext && \
    apk add --no-cache bash && \
    chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
