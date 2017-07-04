$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/char_created_event_handler.rb"
load "lib/time_cmd.rb"
load "lib/time_model.rb"
load "lib/timezone_cmd.rb"
load "ooctime_api.rb"
load "templates/time_template.rb"

module AresMUSH
  module OOCTime
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ooctime", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_time.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "time"
         return TimeCmd
       when "timezone"
         return TimezoneCmd
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharCreatedEvent"
        return CharCreatedEventHandler
      end
      nil
    end
  end
end