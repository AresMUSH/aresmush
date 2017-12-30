$:.unshift File.dirname(__FILE__)



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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "players"
        return GetPlayersRequestHandler
      when "player"
        return GetPlayerRequestHandler
      end
      nil
    end
    
  end
end
