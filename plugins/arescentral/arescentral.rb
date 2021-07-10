$:.unshift File.dirname(__FILE__)



module AresMUSH
  module AresCentral
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("arescentral", "shortcuts")
    end
 
    def self.achievements
      Global.read_config("arescentral", "achievements")
    end
    
    def self.get_cmd_handler(client, cmd, enactor)      
      case cmd.root
      when "game"
        case cmd.switch
        when "register"
          return RegisterGameCmdHandler
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "players"
        return GetPlayersRequestHandler
      when "player"
        return GetPlayerRequestHandler
      when "linkHandle"
        return HandleLinkRequestHandler
      when "UnifyPlayScreen"
        return UnifiedPlayScreenRequestHandler
      end
      nil
    end
    
  end
end
