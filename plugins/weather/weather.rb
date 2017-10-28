$:.unshift File.dirname(__FILE__)
load "engine/weather_change_cmd.rb"
load "engine/weather_cmd.rb"
load "engine/cron_event_handler.rb"
load "engine/game_started_event_handler.rb"
load "lib/helpers.rb"
load "lib/weather_api.rb"

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