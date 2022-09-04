module AresMUSH
    module Openweather
      mattr_accessor :current_weather
  
      def self.can_change_weather?(actor)
        actor.has_permission?("manage_weather")
      end
  
      def self.load_weather_if_needed
        if (Openweather.current_weather == {})
          Openweather.change_all_weathers
        end
      end
  
      def self.change_all_weathers
        # Set an initial weather for each area and the default one
        Openweather.current_weather = {}
        areas = Global.read_config("openweather", "climate_for_area").keys + ["default"]

        Global.dispatcher.spawn("Querying Openweather API", nil) do
            areas.each do |a|
                Openweather.change_weather(a)
            end
          end
      end
  
      def self.change_weather(area)
        # Figure out the climate for this area
        climate = Openweather.climate_for_area(area)
  
        # Save no weather if the weather is disabled for this area.
        if (climate == "none")
          Openweather.current_weather[area] = ""
          return
        end
  
        oweather = Weather.new
        oweather.api_key = Global.read_config('secrets', 'openweather_api_key')
        oweather.units = Global.read_config("openweather", "units")

        if (climate.has_key?("zip"))
          response = oweather.by_zip_code(climate["zip"])
        end

        if (climate.has_key?("coords"))
          response = oweather.by_coords(climate["coords"]["lat"],climate["coords"]["lon"])
        end

        season = ICTime.season(area)
  
        if (!response)
          raise "Could not call API climate for #{climate}."
        end
        
        # Save the weather!
        Openweather.current_weather[area.titlecase] = response.weather
      end

        def self.climate_for_area(area_name)
        area_climates = Global.read_config("openweather", "climate_for_area") || {}

        climate = area_climates.select { |k, v| k.downcase == area_name.downcase }.values.first
        return climate if climate
  
        area = Area.find_one_by_name(area_name)
        if (area && area.parent)
          return Openweather.climate_for_area(area.parent.name)
        else
          return Global.read_config("openweather", "default_climate")
        end
      end
    end
  end