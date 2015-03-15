module AresMUSH
  module Weather
    mattr_accessor :current_weather
   
    def self.can_change_weather?(actor)
      return actor.has_any_role?(Global.config["weather"]["roles"]["can_change_weather"])
    end
    
    def self.change_weather(area)
      # Figure out the climate for this area
      climate = Weather.climate_for_area(area)

      # Save no weather if the weather is disabled for this zone.
      if (climate == "none")
        Weather.current_weather[area] = ""
        return
      end

      season = Weather.season_for_area(area)
      season_config = Global.config["weather"]["climates"][climate][season]

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
      condition = season_config["pattern"].split(/ /).shuffle.first
      temperature = season_config["temperature"].split(/ /).shuffle.first
      
      { :condition => condition, :temperature => temperature }
    end
    
    def self.climate_for_area(area)
      Global.config["weather"]["zones"][area] || Global.config["weather"]["default_zone"]
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
  end
end