$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Lorehooks

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("lorehooks", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "lorehook"
        case cmd.switch
        when "set"
          return LoreHookSetCmd
        when "type"
          return LoreHookTypeCmd
        when "preference"
          return LoreHookPrefCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "getLoreHooks"
        return GetLoreHooksRequestHandler
      end
      nil
    end

  end
end
