module AresMUSH
  module Openweather
    class OpenweatherCmd
      include CommandHandler

      def handle
        list = []
        
        Openweather.load_weather_if_needed
        Openweather.current_weather.each do |k, v|
          weather = Openweather.weather_for_area(k)
          name = k == "default" ? t('Openweather.default') : k
          next if !weather
          list << "%xh#{name}:%xn%r#{weather}"
        end
        template = BorderedDisplayTemplate.new list.join("%R%R")
        client.emit template.render
      end

    end
  end
end
