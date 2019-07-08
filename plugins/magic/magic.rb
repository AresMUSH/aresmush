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
      #Spells
      # case cmd.root
      # when "spell"
      #   return SpellDetailCmd
      # end
      #POTIONS
      #Potions
      case cmd.root
      when "potion"
        case cmd.switch
        when "create"
          return CreatePotionCmd
        when "update"
          return UpdatePotionCmd
        when "give"
          return GivePotionCmd
        when "add"
          return PotionAddCmd
        when "use"
          return PotionUseCmd
        end
      end

      #Spells
      case cmd.root
      when "spell"
        case cmd.switch
        when "cast"
          if cmd.args.include?("=")
            return SpellCastWithTargetCmd
          else
            return SpellCastCmd
          end
        end
      end



      nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return MagicCronEventHandler
      end
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "spells"
        return SpellsRequestHandler
      when "schools"
        return SchoolsRequestHandler
      end
      nil
    end

  end
end
