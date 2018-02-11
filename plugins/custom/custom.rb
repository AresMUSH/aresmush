$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "award"
        if (cmd.switch_is?("remove"))
          return AwardRemoveCmd
        else
          return AwardCmd
        end
      when "condition"
        return ConditionCmd
      when "qual"
        return QualCmd
      when "kill"
        return KillCmd
      end
      nil     
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end
