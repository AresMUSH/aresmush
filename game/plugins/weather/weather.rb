$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/weather_change_cmd.rb"
load "lib/weather_cmd.rb"
load "lib/weather_events.rb"
load "weather_api.rb"

module AresMUSH
  module Weather
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("weather", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_weather.md", "help/weather.md" ]
    end
 
    def self.config_files
      [ "config_weather.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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