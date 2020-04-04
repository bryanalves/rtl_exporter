class SensorToMQTT
  def initialize(mqtt_host)
    @mqtt_host = mqtt_host
  end

  def run
    MQTT::Client.connect(@mqtt_host) do |mqtt|
      mqtt.get('rtl_433/+/events') do |topic, message|
        parsed = JSON.parse(message)

        model = parsed['model']
        id = parsed['id']
        channel = parsed['channel'] || -1

        metadata = {
          id: id,
          model: model,
          channel: channel
        }

        temperature = parsed['temperature_C']
        humidity = parsed['humidity']
        battery = parsed['battery_ok']

        PromRegistry.rtl433_temperature.set(metadata, temperature) if temperature
        PromRegistry.rtl433_humidity.set(metadata, humidity) if humidity
        PromRegistry.rtl433_battery.set(metadata, battery) if battery
      end
    end
  end
end
