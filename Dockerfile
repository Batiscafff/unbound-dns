FROM alpine:3.22.0
COPY entrypoint.sh entrypoint.sh
COPY templates /tmp
COPY loki /etc/loki
#___Unbound_logging_ENV_block___
ENV verbosity="1" \
    log_time_ascii="yes" \
    log_queries="yes" \
#___Unbound_EDNS_&_performance_ENV_block___
    edns_buffer_size="1232" \
    prefetch="yes" \
    cache_min_ttl="3600" \
    cache_max_ttl="86400" \
    num_threads="2" \
    so_rcvbuf="4m" \
    so_sndbuf="4m" \
    rrset_roundrobin="yes" \
    minimal_responses="yes" \
    qname_minimisation="yes" \
#___Unbound_forwarding_ENV_block___
    DNS_FROWARDING_MODE=true \
    forward_addr="9.9.9.11"
#___Global_settings_RUN_block___
RUN apk update && \
    apk upgrade && \
    apk add --no-cache tzdata && \
#___Unbound_RUN_block___
    apk add --no-cache unbound && \
    apk add --no-cache ca-certificates && \
    mkdir -p /var/lib/unbound && \
    mkdir -p /var/log/unbound && \
    wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache && \
    chown unbound:unbound /var/log/unbound && \
    chown -R unbound:unbound /var/lib/unbound && \
    echo "0       0       1       *       *       curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache  && pkill unbound && unbound >> /var/log/unbound/restart.log 2>&1" >> /etc/crontabs/root && \
#___Promtail_RUN_block___
    apk add --no-cache loki-promtail && \
#___Loki_RUN_block___
    apk add --no-cache loki && \
#___Entrypoint_RUN_Block___
    apk add --no-cache gettext && \
    apk add --no-cache bash && \
    chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
