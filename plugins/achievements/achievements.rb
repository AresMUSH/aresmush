$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Achievements

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("achievements", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      if (cmd.root_is?("achievement"))
        return AchievementsCmd
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
