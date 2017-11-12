$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Weather
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("weather", "shortcuts")
    end
 
    def self.load_plugin
      Weather.current_weather = {}
      Weather.change_all_weathers
      self
    end
 
    def self.unload_plugin
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("weather")
      case cmd.switch
      when "set"
        return WeatherChangeCmd
      when nil
        return WeatherCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return WeatherCronEventHandler
      when "GameStartedEvent"
        return WeatherGameStartedEventHandler
      end
    end
  end
end
