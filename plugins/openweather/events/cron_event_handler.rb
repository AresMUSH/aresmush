module AresMUSH
    module Openweather
      class OpenweatherCronEventHandler
        def on_event(event)
  
          # Set initial weather.
          if (!Openweather.current_weather)
            Openweather.change_all_weathers
            return
          end
  
          config = Global.read_config("openweather", "weather_cron")
          return if !Cron.is_cron_match?(config, event.time)
  
          Global.logger.debug "Updating openweather via API calls to internet service."
          Openweather.change_all_weathers
        end
      end
    end
  end