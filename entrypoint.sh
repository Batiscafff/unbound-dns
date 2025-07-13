#!/bin/bash
envsubst < /tmp/unbound.template > /etc/unbound/unbound.conf
rm /tmp/unbound.template
unbound
sleep infinity
