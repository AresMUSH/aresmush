module AresMUSH
  module Weather
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("weather")
    end
    
    def self.weather_for_area(area)
      Weather.load_weather_if_needed
      
      # Get the weather for the current area if there is one.
      weather = Weather.current_weather[area] || Weather.current_weather["default"]

      # This handles the 'no weather' case, returning nil.
      return nil if !weather || weather.empty?

      season = Weather.season_for_area(area)
      time_of_day = ICTime.time_of_day(ICTime.ictime)
      temperature = weather[:temperature]
      condition = weather[:condition]
      
      # Use the weather name in the translation file - like weather.snow 
      weather_desc = Global.read_config("weather", "descriptions", condition) || 
          t('weather.condition', :condition => condition)
      temp_and_time_desc = Global.read_config("weather", "descriptions", "#{temperature}_#{season}_#{time_of_day}") || 
          t('weather.temperature', :temperature => temperature, :season => season, :time_of_day => time_of_day )
      
      "#{temp_and_time_desc} #{weather_desc}"
    end
  end
end