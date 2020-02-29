$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Who
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "hide", "unhide"
        return HideCmd
      when "where"
        return WhereCmd
      when "who"
        return WhoCmd        
      when "whois"
        return WhoisCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "who"
        return WhoRequestHandler
      end
    end
    
    def self.check_config
      validator = WhoConfigValidator.new
      validator.validate
    end
  end
end
