$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Achievements

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("achievements", "shortcuts")
    end
    
    def self.achievements
      Global.read_config("achievements", "achievements")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      if (cmd.root_is?("achievement"))
        case cmd.switch
        when "all"
          return AchievementsAllCmd
        when "add"
          return AchievementAddCmd
        when "remove"
          return AchievementRemoveCmd
        else
          return AchievementsCmd
        end
      end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "achievements"
        return ListAchievementsRequestHandler
      end
    end

    def self.check_config
      validator = AchievementConfigValidator.new
      validator.validate
    end
  end
end
