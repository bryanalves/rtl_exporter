Sensors MQTT format:

`/rtl_433/$$hostname/events => JSON`
`/rtl_433/$$hostname/devices/$$model/$$id/ or`
`/rtl_433/$$hostname/devices/$$model/$$channel/$$id/`
`time`
`id`
`channel`
`temperature_c`
`humidity`
`battery_ok`
`test`


Run with:

`podman build -t rtl_exporter .`
`podman run --rm -it -e RTL_HOST=rtl-tcp.example.com -e MQTT_HOST=mqtt.example.com -e METER_IDS=12345 rtl_exporter`
