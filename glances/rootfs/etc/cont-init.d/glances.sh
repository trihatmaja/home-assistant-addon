#!/usr/bin/env bashio
# ==============================================================================
# Home Assistant Community Add-on: Glances
# Configures Glances
# ==============================================================================
declare protocol
bashio::require.unprotected

# Ensure the configuration exists
if bashio::fs.file_exists '/config/glances/glances.conf'; then
    cp -f /config/glances/glances.conf /etc/glances.conf
else
    mkdir -p /config/glances \
        || bashio::exit.nok "Failed to create the Glances configuration directory"

    # Copy in template file
    cp /etc/glances.conf /config/glances/
fi

# Export Glances data to Prometheus
if bashio::config.true 'prometheus.enabled'; then
    bashio::config.require "prometheus.prefix"
    bashio::config.require "prometheus.labels"
    {
        echo "[prometheus]"
        echo "host=0.0.0.0"
        echo "port=9091"
        echo "prefix=$(bashio::config 'prometheus.prefix')"
        echo "labels=$(bashio::config 'prometheus.labels')"
    } >> /etc/glances.conf
fi
