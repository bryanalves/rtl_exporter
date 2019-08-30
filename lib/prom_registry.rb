class PromRegistry
  def self.registry
    @registry = Prometheus::Client.registry
  end

  def self.rtl433_temperature
    @rtl433_temperature ||= registry.gauge(:rtl433_temperature,
                                           '433 mhz device temperature')
  end

  def self.rtl433_humidity
    @rtl433_humidity ||= registry.gauge(:rtl433_humidity,
                                        '433 mhz device humidity')
  end

  def self.rtl433_battery
    @rtl433_battery ||= registry.gauge(:rtl433_battery,
                                       '433 mhz device battery status')
  end

  def self.meter_consumption
    @meter_consumption ||= registry.gauge(:meter_consumption,
                                          'Electric meter consumption')
  end
end
