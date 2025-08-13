#!/bin/bash
if $DNS_FROWARDING_MODE; then
  cat /tmp/unbound.conf.forward.template >> /tmp/unbound.conf.template
fi
if [ -z "${DATA_REGION}" ]; then
  ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
else
  ln -s /usr/share/zoneinfo/Europe/${DATA_REGION} /etc/localtime
fi
#__________________________Promtail_Block__________________________
echo "0.0.0.0 stats.grafana.org" >> /etc/hosts
promtail -config.file=/etc/loki/promtail-local-config.yaml &
#__________________________Loki_Block__________________________
loki -config.file=/etc/loki/loki-local-config.yaml &
#__________________________Unbound_Block__________________________
envsubst < /tmp/unbound.conf.template > /etc/unbound/unbound.conf
rm /tmp/unbound.conf.template
update-ca-certificates
unbound-anchor -a /var/lib/unbound/root.key
unbound
#__________________________Plug__________________________
sleep infinity
