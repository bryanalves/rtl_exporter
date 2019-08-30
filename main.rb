require 'json'
require 'mqtt'

require 'sinatra/base'
require 'prometheus/client'
require 'prometheus/client/formats/text'

require_relative 'lib/app.rb'
require_relative 'lib/mqtt_bridge.rb'
require_relative 'lib/prom_registry.rb'

require_relative 'lib/meter_fetcher.rb'
require_relative 'lib/sensor_fetcher.rb'

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

Thread.new do
  MQTTBridge.new(ENV['MQTT_HOST']).run
end

App.run!
