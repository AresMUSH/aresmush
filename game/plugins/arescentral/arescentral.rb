$:.unshift File.dirname(__FILE__)
load "connector.rb"
load "lib/event_handlers.rb"
load "lib/game.rb"

module AresMUSH
  module AresCentral
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("arescentral", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [  ]
    end
 
    def self.config_files
      [ "config_arescentral.yml" ]
    end
 
    def self.locale_files
      [  ]
    end
 
    def self.get_cmd_handler(client, cmd)      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end