$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Fate

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("fate", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "stunt"
        case cmd.switch
        when "set"
          return StuntSetCmd
        when "remove"
          return StuntRemoveCmd
        when nil
          return StuntsCmd
        end
      when "aspect"
        case cmd.switch
        when "set"
          return AspectSetCmd
        when "remove"
          return AspectRemoveCmd
        end
      when "sheet"
        return SheetCmd
      when "roll"
        if (cmd.args && cmd.args =~ / vs /)
          return RollOpposedCmd
        else
          return RollCmd
        end
      when "fate"
        case cmd.switch
        when "award"
          return FatePointAwardCmd
        when "spend"
          return FatePointSpendCmd
        end
      when "skill"
        case cmd.switch
        when "set"
          return SkillSetCmd
        when nil
          return SkillsCmd
        end
      end
        
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return RefreshCronHandler
      end
      
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
