$:.unshift File.dirname(__FILE__)
load "connector.rb"
load "lib/arescentral_info_cmd.rb"
load "lib/char_connected_event_handler.rb"
load "lib/cron_event_handler.rb"
load "lib/game_started_event_handler.rb"
load "lib/handle_link_cmd.rb"
load "lib/game_reg.rb"
load "public/arescentral_api.rb"

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
 
    def self.config_files
      [ "config_arescentral.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)      
      case cmd.root
      when "arescentral"
        case cmd.switch
        when "info", nil
          return AresCentralInfoCmd
        end
        
      when "handle"
        case cmd.switch
        when "link"
          return HandleLinkCmd
        end
      end
        
    end
    
    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      when "GameStartedEvent"
        return GameStartedEventHandler
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
  end
end