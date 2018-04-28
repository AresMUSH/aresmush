module AresMUSH

  module Weather
    class WeatherChangeCmd
      include CommandHandler
      
      attr_accessor :temp, :condition, :area
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.area = titlecase_arg(args.arg1)
        self.temp = downcase_arg(args.arg2)
        self.condition = downcase_arg(args.arg3)
      end
      
      def required_args
        [ self.temp, self.condition, self.area ]
      end
      
      def check_can_change_weather
        return t('dispatcher.not_allowed') if !Weather.can_change_weather?(enactor)
        return nil
      end
      
      def check_condition
        conditions = Global.read_config("weather", "conditions")
        return t('weather.invalid_condition', :conditions => conditions.join(" ")) if !conditions.include?(self.condition)
        return nil
      end
      
      def check_temp
        temperatures = Global.read_config("weather", "temperatures")
        return t('weather.invalid_temperature', :temps => temperatures.join(" ")) if !temperatures.include?(self.temp)
        return nil
      end
      
      def handle
        Weather.current_weather[self.area] = { :condition => self.condition, :temperature => self.temp }
        client.emit_success t('weather.weather_set', :area => self.area)
      end
        
    end
  end
end
