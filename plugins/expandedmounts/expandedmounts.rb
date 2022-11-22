$:.unshift File.dirname(__FILE__)

module AresMUSH
  module ExpandedMounts

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("expandedmounts", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "mounts"
        return ExpandedMountsListCmd
      end
      case cmd.root
      when "mount"
        case cmd.switch
        when "hero"
          return CombatMountHeroCmd
        when "roll"
          if (cmd.args =~ / vs /)
            return ExpandedMountsOpposedRollCmd
          else
            return ExpandedMountsRollCmd
          end
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return ExpandedMountsDamageCronHandler
      end
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
