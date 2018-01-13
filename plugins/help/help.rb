$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Help
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("help", "shortcuts")
    end
 
    def self.load_plugin
      Help.reload_help
      self
    end
 
    def self.unload_plugin
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       return nil if !cmd.root.end_with?("help")
       
       if (cmd.args)
         return HelpViewCmd
       else
         return HelpListCmd
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "help"
        return HelpIndexRequestHandler
      when "helpTopic"
        return HelpTopicRequestHandler
      end
      nil
    end
  end
end
