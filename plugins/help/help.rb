$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Help
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("help", "shortcuts")
    end
 
    def self.init_plugin
      Help.reload_help
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "beginner"
         return BeginnerCmd
       when "help"
         case cmd.switch
         when "quick"
           return HelpQuickrefCmd
         else
           if (cmd.args)
             return HelpViewCmd
           else
             return HelpListCmd
           end
         end
       end
       
       nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "help"
        return HelpIndexRequestHandler
      when "helpTopic"
        return HelpTopicRequestHandler
      when "searchHelp"
        return SearchHelpRequestHandler
      when "overrideHelp"
        return HelpOverrideRequestHandler
      when "restoreHelp"
        return HelpRestoreRequestHandler
      end
      nil
    end
  end
end
