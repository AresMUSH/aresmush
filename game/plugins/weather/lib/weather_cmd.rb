module AresMUSH

  module Weather
    class WeatherCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        list = []
        Weather.current_weather.each do |k, v| 
          weather = Weather.weather_for_area(k)
          name = k == "default" ? t('weather.default') : k
          next if weather.nil?
          list << "%xh#{name}:%xn%r#{weather}"
        end
        client.emit BorderedDisplay.text list.join("%R%R")
      end
    end
  end
end
