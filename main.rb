require 'json'
require 'mqtt'

require 'sinatra/base'
require 'prometheus/client'
require 'prometheus/client/formats/text'

require_relative 'lib/app.rb'
require_relative 'lib/prom_registry.rb'

require_relative 'lib/meter/fetcher.rb'
require_relative 'lib/meter/mqtt.rb'

require_relative 'lib/sensor/fetcher.rb'
require_relative 'lib/sensor/mqtt.rb'

def run_fetchers
  Thread.new do
    meter_fetcher = MeterFetcher.new(rtl_host: ENV['RTL_HOST'],
                                     mqtt_host: ENV['MQTT_HOST'],
                                     meter_ids: ENV['METER_IDS'])

    sensor_fetcher = SensorFetcher.new(rtl_host: ENV['RTL_HOST'],
                                       mqtt_host: ENV['MQTT_HOST'])

    loop do
      meter_fetcher.run
      sensor_fetcher.run
    end
  end
end

def sensor_to_mqtt
  Thread.new do
    SensorToMQTT.new(ENV['MQTT_HOST']).run
  end
end

def meter_to_mqtt
  Thread.new do
    MeterToMQTT.new(ENV['MQTT_HOST']).run
  end
end

sensor_to_mqtt
App.run!
