$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Ffg

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("ffg", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "archetype"
        return ArchetypesCmd
      when "characteristic"
        if (cmd.switch_is?("set"))
          return CharacteristicSetCmd
        else
          return CharacteristicsCmd
        end
      when "skill"
        if (cmd.switch_is?("set"))
          return SkillSetCmd
        else
          return SkillsCmd
        end
      when "specialization"
        if (cmd.switch_is?("add"))
          return SpecAddCmd
        elsif (cmd.switch_is?("remove"))
          return SpecRemoveCmd
        end
      when "talent"
        if (cmd.switch_is?("add"))
          return TalentAddCmd
        elsif (cmd.switch_is?("remove"))
          return TalentRemoveCmd
        else
          return TalentsCmd
        end
      when "force", "wound", "strain"
        return StatSetCmd
      when "career"
        return CareersCmd
      when "reset"
        return ResetCmd
      when "sheet"
        return SheetCmd
      when "roll"
        if (cmd.args && cmd.args =~ / vs /)
          return RollOpposedCmd
        else
          return RollCmd
        end
      when "xp"
        if (cmd.switch_is?("award"))
          return XpAwardCmd
        end
      when "story"
        if (cmd.switch_is?("award"))
          return StoryPointAwardCmd
        elsif (cmd.switch_is?("spend"))
          return StoryPointSpendCmd
        end
      end
      return nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
