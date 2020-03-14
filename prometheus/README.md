# Home Assistant Add-on: Prometheus

Prometheus server for Home Assistant.

![Supports armv7 Architecture][armv7-shield] ![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield]


## About

You can use this add-on as an alternative to influxdb. This add-on support for the external prometheus to write your data.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Find the "Prometheus" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

1. Start the add-on.
2. Have some patience and wait a couple of minutes.
3. Check the add-on log output to see the result.

If the log ends with `no error found! :)`,
it means the check against your configuration passes on the specified
Home Assistant version.

## Configuration

Add-on configuration:

```yaml
"log_level": "info",
"scrape_interval": 15,
"token": "",
"latitude": "",
"longitude": "",
"remote_write": ""
```

### Option: `log_level`

The log level of the Prometheus addons

Setting this option to `info` will result in print all the log.

### Option: `scrape_interval` (seconds)

The interval for prometheus server to scrap the metrics in seconds. The default value is 15 seconds


### Option: `token`

The long lived token use to access Home-Assistant api.

### Option: `latitude`

The latitude of current Home-Assistant.

### Option: `longitude`

The longitude of current Home-Assistant.

### Option: `remote_write`

The url for the external prometheus db such [thanos] or [victoriametrics].


## Known issues and limitations

- Need to findout

## Support

Got questions?

You have several options to get them answered:

In case you've found a bug, please [open an issue on our GitHub][issue].

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[issue]: https://github.com/trihatmaja/addon-prometheus/issue
[repository]: https://github.com/trihatmaja/addon-prometheus
[thanos]: https://thanos.io/
[victoriametrics]: https://victoriametrics.com/