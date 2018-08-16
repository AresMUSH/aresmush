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

    #Secrets
      case cmd.root
      when "secrets"
        case cmd.switch
        when "set"
          return SetSecretsCmd
        else
          return SecretsCmd
        end
      end
      case cmd.root
      when "gmsecrets"
        case cmd.switch
        when "set"
          return SetGMSecretsCmd
        else
          return GMSecretsCmd
        end
      end
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
        when "use"
          return PotionUseCmd
        end
      end
      case cmd.root
      when "potions"
        return PotionsCmd
      end
    #Spells
      case cmd.root
      when "spell"
        case cmd.switch
        when "request"
          return SpellRequestCmd
        when "mod"
          return SpellModCmd
        when "modis"
          return SpellModIsCmd
        when "cast"
          if cmd.args.include?("=")
            return SpellCastWithTargetCmd
            client.emit "With target."
          else
            return SpellCastCmd
          end
        when "learn"
          return SpellLearnCmd
        end
      end
      case cmd.root
      when "spells"
        return SpellsCmd
      end
    #Schools
      case cmd.root
      when "school"
        case cmd.switch
        when "set"
          return SetSchoolsCmd
        else
          return SchoolsCmd
        end
      end


      return nil
    end
  end
end
