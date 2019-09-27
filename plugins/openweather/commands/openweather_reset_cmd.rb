module AresMUSH

    module Openweather
      class OpenweatherResetCmd
        include CommandHandler
  
        def check_can_change_weather
          return t('dispatcher.not_allowed') if !Openweather.can_change_weather?(enactor)
          return nil
        end
  
  
        def handle
          Openweather.change_all_weathers
          client.emit_success t('Openweather.weather_reset')
        end
  
      end
    end
  end