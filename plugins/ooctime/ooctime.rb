$:.unshift File.dirname(__FILE__)

require 'timezone'

module AresMUSH
  module OOCTime
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ooctime", "shortcuts")
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
    
    def self.check_config
      validator = OOCTimeConfigValidator.new
      validator.validate
    end
  end
end
