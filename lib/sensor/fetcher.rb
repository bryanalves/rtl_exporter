class SensorFetcher
  def initialize(rtl_host:,
                 mqtt_host:,
                 rtl_port: 1234,
                 sensor_time: 30)
    @sensor_time = sensor_time
    @rtl_conn = "#{rtl_host}:#{rtl_port}"
    @mqtt_host = mqtt_host
  end

  def run
    `#{sensors_cmd}`
  end

  private

  def sensors_cmd
    "rtl_433 \
      -d rtl_tcp:#{@rtl_conn} \
      -M newmodel \
      -T #{@sensor_time} \
      -F mqtt://#{@mqtt_host}"

      # -F json
  end
end

