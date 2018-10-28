module AresMUSH
  module Weather
    class WeatherCronEventHandler
      def on_event(event)
        
        # Set initial weather.
        if (!Weather.current_weather)
          Weather.change_all_weathers
          return
        end
        
        config = Global.read_config("weather", "weather_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Updating weather."
        Weather.change_all_weathers
      end
    end
  end
end