$:.unshift File.dirname(__FILE__)

load "engine/char_connected_event_handler.rb"
load "engine/cron_event_handler.rb"
load "engine/game_started_event_handler.rb"
load "engine/handle_link_cmd.rb"
load "lib/connector.rb"
load "lib/game_reg.rb"
load "lib/arescentral_api.rb"
load "lib/arescentral_model.rb"
load 'web/controllers/players.rb'


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