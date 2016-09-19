$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/weather_change_cmd.rb"
load "lib/weather_cmd.rb"
load "lib/weather_cron.rb"
load "weather_interfaces.rb"

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
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end