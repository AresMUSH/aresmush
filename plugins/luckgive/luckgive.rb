$:.unshift File.dirname(__FILE__)

module AresMUSH
     module LuckGive

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("luckgive", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "luck"
        case cmd.switch
        when "give"
          return LuckGiveCmd
        when "record"
          return LuckRecordCmd
        end
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
