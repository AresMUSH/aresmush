module AresMUSH

  module Weather
    class WeatherCmd
      include CommandHandler
      
      def handle
        list = []

        Weather.load_weather_if_needed
        Weather.current_weather.each do |k, v| 
          weather = Weather.weather_for_area(k)
          name = k == "default" ? t('weather.default') : k
          next if !weather
          list << "%xh#{name}:%xn%r#{weather}"
        end
        template = BorderedDisplayTemplate.new list.join("%R%R")
        client.emit template.render
      end
    end
  end
end
