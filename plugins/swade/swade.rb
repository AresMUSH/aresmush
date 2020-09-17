$:.unshift File.dirname(__FILE__)

module AresMUSH
	module SWADE
		
    def self.plugin_dir
      File.dirname(__FILE__)
    end
    
	def self.shortcuts
      Global.read_config("swade", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "race"
        if (cmd.switch_is?("set"))
          return RaceSetCmd
        else
          return RaceCmd
        end
      when "framework"
        if (cmd.switch_is?("set"))
          return FrameworkSetCmd
        else
          return FrameworkCmd
        end
      when "hinderance"
        if (cmd.switch_is?("set"))
          return HinderanceSetCmd
        else
          return HinderanceCmd
        end
      when "edge"
        if (cmd.switch_is?("set"))
          return EdgeSetCmd
        else
          return EdgeCmd
        end
	  when "attribute"
        if (cmd.switch_is?("set"))
          return AttributeSetCmd
        else
          return AttributesCmd
        end
      when "skill"
        if (cmd.switch_is?("set"))
          return SkillSetCmd
        else
          return SkillsCmd
        end
      when "sheet"
        return SheetCmd
      when "reset"
        return ResetCmd
      when "roll"
        return RollCmd
      when "advance"
        if (cmd.switch_is?("award"))
          return AdvancementPointAwardCmd
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
