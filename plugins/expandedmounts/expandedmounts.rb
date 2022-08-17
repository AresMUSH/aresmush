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
      # case cmd.root
      # when "combat"
      #   case cmd.switch
      #   when "mount"
      #     return ExpandedCombatMountCmd
      #   when "dismount"
      #     return ExpandedCombatDismountCmd
      #   when "test"
      #     return ExpandedCombatMountCmd
      #   end
      # end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
