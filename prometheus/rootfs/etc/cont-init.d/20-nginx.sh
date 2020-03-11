#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus
# Configures NGINX for use with ttyd
# ==============================================================================
declare dns_host
declare ingress_interface
declare ingress_port

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/nginx.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/nginx.conf

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/nginx.conf