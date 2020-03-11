#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Prometheus
# Configures Prometheus
# ==============================================================================

declare token
declare latitude
declare longitude
declare remote_write
declare target
declare port

token=$(bashio::config 'token')
latitude=$(bashio::config 'latitude')
longitude=$(bashio::config 'longitude')
remote_write=$(bashio::config 'remote_write')

target_ip=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/info' | jq -r '.data.ip_address')
target_port=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/info' | jq -r '.data.port')

sed -i "s/%%target_ip%%/${target_ip}/g" /etc/prometheus/prometheus.yml
sed -i "s/%%target_port%%/${target_port}/g" /etc/prometheus/prometheus.yml

if bashio::var.has_value "${token}"; then
	sed -i "s/%%token%%/${token}/g" /etc/prometheus/prometheus.yml
else
	sed -i "s/%%token%%/${SUPERVISOR_TOKEN}/g" /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${latitude}"; then
	sed -i "s/%%latitude%%/${latitude}/g" /etc/prometheus/prometheus.yml
else
	sed '/%%latitude%%/d' /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${longitude}"; then
	sed -i "s/%%longitude%%/${longitude}/g" /etc/prometheus/prometheus.yml
else
	sed '/%%longitude%%/d' /etc/prometheus/prometheus.yml
fi

if bashio::var.has_value "${remote_write}"; then
	sed -i "s/%%remote_write%%/${remote_write}/g" /etc/prometheus/prometheus.yml
else
	sed '/%%remote_write%%/d' /etc/prometheus/prometheus.yml
	sed '/url:/d' /etc/prometheus/prometheus.yml
fi