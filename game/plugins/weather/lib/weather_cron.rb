module AresMUSH
  module Weather
    class WeatherCronHandler
      include Plugin

      def on_config_updated_event(event) 
        Weather.current_weather = {}
        change_all_weathers
      end

      def on_cron_event(event)
        config = Global.config['weather']['cron']
        return if !Cron.is_cron_match?(config, event.time)

        change_all_weathers
      end

      def change_all_weathers
        # Set an initial weather for each area and the default one
        areas = Global.config["weather"]["zones"].keys + ["default"]
        areas.each do |a|
          Weather.change_weather(a)
        end
      end
    end
  end
end