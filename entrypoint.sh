#!/bin/bash
#__________________________Promtail_Block__________________________
echo "0.0.0.0 stats.grafana.org" >> /etc/hosts
promtail -config.file=/etc/loki/promtail-local-config.yaml &
#__________________________Loki_Block__________________________
loki -config.file=/etc/loki/loki-local-config.yaml &
#__________________________Unbound_Block__________________________
envsubst < /tmp/unbound.template > /etc/unbound/unbound.conf
rm /tmp/unbound.template
unbound-anchor -a /var/lib/unbound/root.key
unbound
#__________________________Plug__________________________
sleep infinity
