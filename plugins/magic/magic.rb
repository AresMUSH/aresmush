$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Magic

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("magic", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return ShieldCronHandler
      end
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
