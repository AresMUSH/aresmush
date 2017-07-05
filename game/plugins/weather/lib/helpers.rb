module AresMUSH
  module Weather
    mattr_accessor :current_weather
   
    def self.can_change_weather?(actor)
      actor.has_permission?("change_weather")
    end
    
    def self.change_all_weathers
      # Set an initial weather for each area and the default one
      areas = Global.read_config("weather", "climate_for_area").keys + ["default"]
      areas.each do |a|
        Weather.change_weather(a)
      end
    end
      
    def self.change_weather(area)
      # Figure out the climate for this area
      climate = Weather.climate_for_area(area)

      # Save no weather if the weather is disabled for this area.
      if (climate == "none")
        Weather.current_weather[area] = ""
        return
      end

      season = Weather.season_for_area(area)
      
      climate_config = Global.read_config("weather", "climates", climate)
      season_config = climate_config[season]

      # Get the current weather
      weather = Weather.current_weather[area]

      # Make a stability roll to see if the weather actually changes.  
      # Also change it if the weather was never set.
      if (!weather || rand(100) < season_config["stability"])
        weather = Weather.random_weather(season_config)
      end

      # Save the weather!
      Weather.current_weather[area] = weather
    end

    def self.random_weather(season_config)
      condition = season_config["condition"].split(/ /).shuffle.first
      temperature = season_config["temperature"].split(/ /).shuffle.first
      
      { :condition => condition, :temperature => temperature }
    end
    
    def self.climate_for_area(area)
      Global.read_config("weather", "climate_for_area", area) || Global.read_config("weather", "default_climate")
    end

    # You can make this fancier to account for months like March which are
    # split across seasons.
    def self.season_for_area(area)
      case ICTime.ictime.month
      when 12, 1, 2
        'winter'
      when 3, 4, 5
        'spring'
      when 6, 7, 8
        'summer'
      when 9, 10, 11
        'fall'
      end
    end
    
    def self.weather_for_area(area)
      # Get the weather for the current area if there is one.
      weather = Weather.current_weather[area] || Weather.current_weather["default"]

      # This handles the 'no weather' case, returning nil.
      return nil if weather.empty?

      season = Weather.season_for_area(area)
      time_of_day = ICTime.time_of_day(ICTime.ictime)
      temperature = weather[:temperature]
      condition = weather[:condition]
      
      # Use the weather name in the translation file - like weather.snow 
      weather_desc = t("weather.#{condition}")
      temp_and_time_desc = t("weather.#{temperature}_#{season}_#{time_of_day}")
      
      "#{temp_and_time_desc} #{weather_desc}"
    end
  end
end