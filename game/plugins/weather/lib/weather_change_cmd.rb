module AresMUSH

  module Weather
    class WeatherChangeCmd
      include CommandHandler
      
      attr_accessor :temp, :condition, :area
      
      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2_slash_arg3)
        self.area = titleize_input(cmd.args.arg1)
        self.temp = !cmd.args.arg2 ? nil : trim_input(cmd.args.arg2).downcase
        self.condition = !cmd.args.arg3 ? nil : trim_input(cmd.args.arg3).downcase
      end
      
      def required_args
        {
          args: [ self.temp, self.condition, self.area ],
          help: 'weather'
        }
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
        client.emit t('weather.weather_set', :area => self.area)
      end
        
    end
  end
end
