module AresMUSH
  module Weather
    class WeatherCronEventHandler
      def on_event(event)
        config = Global.read_config("weather", "cron")
        return if !Cron.is_cron_match?(config, event.time)

        Weather.change_all_weathers
      end
    end
  end
end