module AresMUSH
    module Openweather
      def self.is_enabled?
        !Global.plugin_manager.is_disabled?("Openweather")
      end
  
      def self.weather_for_area(area_name)  
        Openweather.load_weather_if_needed
  
        # Get the weather for the current area if there is one.
        if (Openweather.current_weather.has_key?(area_name))
          weather = Openweather.current_weather[area_name]
        else
          area = Area.find_one_by_name(area_name)
          if (area && area.parent)
            return Openweather.weather_for_area(area.parent.name)
          end
          weather = Openweather.current_weather["Default"]
        end
  
        # This handles the 'no weather' case, returning nil.
        return nil if !weather || weather.empty?
        # This handles any 404 errors
        return nil if weather[:cod]=="404"
  
        season = ICTime.season(area_name)

        # Season and Time of day are 'generic' and not based off
        # Openweather's sunset and sunrise times for an area.
        # Possible TODO?
        
        time_of_day = ICTime.time_of_day(area_name)
      
        units = Global.read_config("openweather", "units") 
        degree = "\u00B0"

        case units
          when "imperial" then units=["F","mph"]
          when "metric" then units=["C","m/sec"]
        end

        temperature = weather[:main][:temp] || 0
        humidity = weather[:main][:humidity] || 0
        wind_speed = weather[:wind][:speed] || 0
        wind_deg = weather[:wind][:deg] || 0

        x = wind_deg % 360
        x = (x/22.5)+1
        
        wind_dir = t("Openweather.wind_#{x.round}")

        # Weather is in an array list, The most recent the last element.

        condition = weather[:weather].last[:description]
        condition_id = weather[:weather].last[:id]

        # Read the code desc from config, or use the api crappy description

        weather_desc = Global.read_config("openweather", "weather_code_desc", condition_id) ||
          t('Openweather.condition', :condition => condition)

        temp_desc =  t('Openweather.temperature', :temperature => temperature, :degree => degree.encode('utf-8'),
                        :unit => units[0], :humidity => humidity, :season => season, :time_of_day => time_of_day)

        wind_desc = t('Openweather.winds', :wind_speed => wind_speed, :unit => units[1], :wind_dir => wind_dir)

        "#{temp_desc} #{wind_desc} #{weather_desc}"
      

      end
    end
  end