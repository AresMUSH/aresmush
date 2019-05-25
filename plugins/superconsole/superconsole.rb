$:.unshift File.dirname(__FILE__)

module AresMUSH
     module SuperConsole

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("superconsole", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
        case cmd.root
        when "sheet"
         if (cmd.switch_is?("learn"))
           return SheetLearnCmd
         else
           return SheetCmd
         end
        else
          nil
        end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
