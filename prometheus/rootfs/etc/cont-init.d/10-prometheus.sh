#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Prometheus
# Configures Prometheus
# ==============================================================================

declare token
declare latitude
declare longitude
declare latitude_conf
declare longitude_conf
declare remote_write
declare target
declare port
declare scrape_interval
declare additional_job_name
declare additional_metrics_path
declare additional_target

token=$(bashio::config 'token')
latitude=$(bashio::config 'latitude')
longitude=$(bashio::config 'longitude')
remote_write=$(bashio::config 'remote_write')
scrape_interval=$(bashio::config 'scrape_interval')
ingress_entry=$(bashio::addon.ingress_entry)

latitude_conf=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/api/config' | jq -r '.latitude')
longitude_conf=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/api/config' | jq -r '.longitude')

additional_job_name=$(bashio::config 'additional_job_name')
additional_metrics_path=$(bashio::config 'additional_metrics_path')
additional_target_url=$(bashio::config 'additional_target_url')

sed -i "s#%%target%%#supervisor#g" /etc/prometheus/prometheus.yml
# sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/prometheus/prometheus.yml

if bashio::var.has_value "${token}"; then
	sed -i "s/%%token%%/${token}/g" /etc/prometheus/prometheus.yml
else
	sed -i "s/%%token%%/${SUPERVISOR_TOKEN}/g" /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${scrape_interval}"; then
	sed -i "s/%%scrape_interval%%/${scrape_interval}/g" /etc/prometheus/prometheus.yml
else
	sed -i "s/%%scrape_interval%%/15/g" /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${latitude}"; then
	sed -i "s/%%latitude%%/${latitude}/g" /etc/prometheus/prometheus.yml
else
	sed -i "s/%%latitude%%/${latitude_conf}/g" /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${longitude}"; then
	sed -i "s/%%longitude%%/${longitude}/g" /etc/prometheus/prometheus.yml
else
	sed -i "s/%%longitude%%/${longitude_conf}/g" /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${remote_write}"; then
	sed -i "s#%%remote_write%%#${remote_write}#g" /etc/prometheus/prometheus.yml
else
	sed -i '/%%remote_write%%/d' /etc/prometheus/prometheus.yml
	sed -i '/url:/d' /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${additional_job_name}"; then
	sed -i "s#%%additional_job_name%%#${additional_job_name}#g" /etc/prometheus/prometheus.yml
	sed -i "s#%%additional_metrics_path%%#${additional_metrics_path}#g" /etc/prometheus/prometheus.yml
	sed -i "s#%%additional_target%%#${additional_target_url}#g" /etc/prometheus/prometheus.yml
else
	sed -i '22d;23d;24d;25d' /etc/prometheus/prometheus.yml
fi
