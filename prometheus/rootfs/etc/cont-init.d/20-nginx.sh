#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus
# Configures NGINX for use with ttyd
# ==============================================================================
declare dns_host

dns_host=$(bashio::dns.host)
ingress_port=$(bashio::addon.ingress_port)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/nginx.conf
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/nginx.conf