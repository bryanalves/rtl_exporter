class MeterToMQTT
  def initialize(mqtt_host)
    @mqtt_host = mqtt_host
  end

  def run
    MQTT::Client.connect(@mqtt_host) do |mqtt|
      mqtt.get('rtlamr/#') do |_topic, message|
        parsed = JSON.parse(message)

        message_type = parsed['message_type']
        type = parsed['type']
        id = parsed['id']

        metadata = {
          id: id,
          message_type: message_type,
          type: type
        }

        consumption = parsed['consumption']

        PromRegistry.rtlamr_consumption.set(metadata, consumption)
      end
    end
  end
end
