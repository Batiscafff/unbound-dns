#!/bin/bash
envsubst < /tmp/unbound.template > /etc/unbound/unbound.conf
rm /tmp/unbound.template
loki -config.file=/etc/loki/loki-local-config.yaml &
promtail -config.file=/etc/loki/promtail-local-config.yaml &
unbound
sleep infinity
