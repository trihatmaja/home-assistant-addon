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
declare remote_write_url
declare remote_write_username
declare remote_write_password
declare target
declare port
declare scrape_interval
declare additional_job

token=$(bashio::config 'token')
latitude=$(bashio::config 'latitude')
longitude=$(bashio::config 'longitude')
remote_write_url=$(bashio::config 'remote_write_url')
remote_write_username=$(bashio::config 'remote_write_username')
remote_write_password=$(bashio::config 'remote_write_password')
scrape_interval=$(bashio::config 'scrape_interval')
ingress_entry=$(bashio::addon.ingress_entry)

latitude_conf=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/api/config' | jq -r '.latitude')
longitude_conf=$(curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" -s 'http://supervisor/core/api/config' | jq -r '.longitude')


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

if bashio::var.has_value "${remote_write_url}"; then
	sed -i "s#%%remote_write_url%%#${remote_write_url}#g" /etc/prometheus/prometheus.yml

	if bashio::var.has_value "${remote_write_username}"; then
			sed -i "s#%%remote_write_username%%#${remote_write_username}#g" /etc/prometheus/prometheus.yml
			sed -i "s#%%remote_write_password%%#${remote_write_password}#g" /etc/prometheus/prometheus.yml
	else
			sed -i '/basic_auth:/d' /etc/prometheus/prometheus.yml
			sed -i '/username:/d' /etc/prometheus/prometheus.yml
			sed -i '/password:/d' /etc/prometheus/prometheus.yml
	fi
else
	sed -i '/%%remote_write_url%%/d' /etc/prometheus/prometheus.yml
	sed -i '/url:/d' /etc/prometheus/prometheus.yml
	sed -i '/basic_auth:/d' /etc/prometheus/prometheus.yml
	sed -i '/username:/d' /etc/prometheus/prometheus.yml
	sed -i '/password:/d' /etc/prometheus/prometheus.yml

fi

for job in $(bashio::config 'additional_job|keys'); do
	if bashio::var.has_value "additional_job[${job}].name"; then
		
		job_name=$(bashio::config "additional_job[${job}].name")
		metrics_path=$(bashio::config "additional_job[${job}].metrics_path")
		targets=$(bashio::config "additional_job[${job}].targets")

		# start append to the existing config
		echo "  - job_name: ${job_name}" >> /etc/prometheus/prometheus.yml
		echo "    metrics_path: ${metrics_path}" >> /etc/prometheus/prometheus.yml
		echo "    static_configs:" >> /etc/prometheus/prometheus.yml
		echo "    - targets: [\"${targets}\"]" >> /etc/prometheus/prometheus.yml

		if bashio::var.has_value "additional_job[${job}].username"; then
			username=$(bashio::config "additional_job[${job}].username")
			password=$(bashio::config "additional_job[${job}].password")
			
			echo "    basic_auth:" >> /etc/prometheus/prometheus.yml
			echo "      username: ${username}" >> /etc/prometheus/prometheus.yml
			echo "      password: ${password}" >> /etc/prometheus/prometheus.yml
		

		fi
	fi
done
