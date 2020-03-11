#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Prometheus
# Configures NGINX for use with ttyd
# ==============================================================================
declare dns_host

mkdir -p /var/log/nginx

dns_host=$(bashio::dns.host)
sed -i "s#%%dns_host%%#${dns_host}#g" /etc/nginx/nginx.conf