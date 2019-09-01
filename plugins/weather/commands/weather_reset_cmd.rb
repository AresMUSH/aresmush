module AresMUSH

  module Weather
    class WeatherResetCmd
      include CommandHandler
    
      def check_can_change_weather
        return t('dispatcher.not_allowed') if !Weather.can_change_weather?(enactor)
        return nil
      end
      
      
      def handle
        Weather.change_all_weathers
        client.emit_success t('weather.weather_reset')
      end
        
    end
  end
end
