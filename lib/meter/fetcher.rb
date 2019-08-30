class MeterFetcher
  def initialize(rtl_host:,
                 mqtt_host:,
                 meter_ids: nil,
                 rtl_port: 1234,
                 meter_time: 30)
    @rtl_conn = "#{rtl_host}:#{rtl_port}"
    @meter_time = meter_time
    @mqtt_host = mqtt_host
    @meter_ids = meter_ids.to_s
  end

  def run
    meter_json = gather(meters_cmd)
    output_meters_mqtt meter_json
    output_values meter_json
  end

  private

  def gather(cmd)
    `#{cmd}`.lines.map do |json|
      begin
        JSON.parse(json)
      rescue JSON::ParserError
        nil
      end
    end.compact
  end

  def meters_cmd
    return @meters_cmd if @meters_cmd

    extra = "-filterid=#{@meter_ids} -single=true" unless @meter_ids.empty?

    @meters_cmd = "/root/go/bin/rtlamr \
      #{extra} \
      -server=#{@rtl_conn} \
      -msgtype=all \
      -duration=#{@meter_time}s \
      -format=json \
      -unique"
  end

  def output_values(json)
    puts json
  end

  def output_meters_mqtt(json)
    MQTT::Client.connect(@mqtt_host) do |mqtt|
      json.each do |item|
        message_type = item['Type']
        message = item['Message']

        case message_type
        when 'SCM'
          publish_scm(mqtt, message)
        when 'SCM+'
          publish_scm_plus(mqtt, message)
        when 'R900'
          publish_r900(mqtt, message)
        end
      end
    end
  end

  def publish_scm(mqtt, message)
    id = message['ID']
    type = message['Type']
    consumption = message['Consumption']

    mqtt_message = {
      message_type: 'scm',
      type: type,
      id: id,
      consumption: consumption
    }

    mqtt.publish("rtlamr/events/", mqtt_message.to_json)
  end

  def publish_scm_plus(mqtt, message)
    id = message['EndpointID']
    type = message['EndpointType']
    consumption = message['Consumption']

    mqtt_message = {
      message_type: 'scm+',
      type: type,
      id: id,
      consumption: consumption
    }

    mqtt.publish('rtlamr/events', mqtt_message.to_json)
  end

  def publish_r900(mqtt, message)
    id = message['ID']
    consumption = message['Consumption']

    mqtt_message = {
      message_type: 'r900',
      id: id,
      consumption: consumption
    }

    mqtt.publish('rtlamr/events', mqtt_message.to_json)
  end
end
