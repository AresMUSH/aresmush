$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end

    def self.get_web_request_handler(request)
      case request.cmd
      # when "spells"
      #   return SpellsRequestHandler
      # when "schools"
      #   return SchoolsRequestHandler
      when "searchSpells"
        return SearchSpellsRequestHandler
      when "getSchools"
        return GetSchoolsRequestHandler
      when "getSecrets"
        return GetSecretsRequestHandler
      end
      nil
    end

    def self.get_cmd_handler(client, cmd, enactor)

      case cmd.root
      when "lastrp"
        return LastRPCmd
      end

      # case cmd.root
      # when "shield"
      #   case cmd.switch
      #   when "off"
      #     return ShieldOffCmd
      #   end
      # end

      #Comps
      case cmd.root
      when "comp"
        return CompGiveCmd
      when "comps"
        return CompsCmd
      end

      #Plots
      case cmd.root
      when "plot"
        case cmd.switch
        when "propose"
          return PlotProposeCmd
        end
      end

      #PlotPrefs
      case cmd.root
      when "plotprefs"
        case cmd.switch
        when "set"
          return PlotPrefsSetCmd
        when nil
          return PlotPrefsViewCmd
        end
      end

      #Secrets
      case cmd.root
      when "secrets"
        case cmd.switch
        when "set"
          return SetSecretsCmd
        when "preference"
          return SetSecretPrefCmd
        when "setplot"
          return SetSecretsPlotCmd
        when nil
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
      #Items
      case cmd.root
      when "items"
        return ItemsCmd
      end
      case cmd.root
      when "item"
        case cmd.switch
        when "add"
          return ItemAddCmd
        when "equip"
          return ItemEquipCmd
        when "unequip"
          return ItemUnequipCmd
        when "remove"
          return ItemRemoveCmd
        when "give"
          return GiveItemCmd
        end
      end
      # #Potions
      # case cmd.root
      # when "potion"
      #   case cmd.switch
      #   when "create"
      #     return CreatePotionCmd
      #   when "update"
      #     return UpdatePotionCmd
      #   when "give"
      #     return GivePotionCmd
      #   when "add"
      #     return PotionAddCmd
      #   when "use"
      #     if cmd.args.include?("=")
      #       return PotionUseWithTargetCmd
      #     else
      #       return PotionUseCmd
      #     end
      #   end
      # end
      case cmd.root
      when "potions"
        return PotionsCmd
      end
      #Spells
      # case cmd.root
      # when "spell"
      #   case cmd.switch
      #   when "request"
      #     return SpellRequestCmd
      #   when "mod"
      #     return SpellModCmd
      #   when "modis"
      #     return SpellModIsCmd
      #   when "cast"
      #     if cmd.args.include?("=")
      #       return SpellCastWithTargetCmd
      #     else
      #       return SpellCastCmd
      #     end
      #   when "learn"
      #     return SpellLearnCmd
      #   when "luck"
      #     return SpellLuckCmd
      #   when "discard"
      #     return SpellDiscardCmd
      #   when "add"
      #     return SpellAddCmd
      #   when "remove"
      #     return SpellRemoveCmd
      #   when "hascast"
      #     return SpellHascastCmd
      #   end
      #   return SpellDetailCmd
      # end

      # case cmd.root
      # when "spells"
      #   return SpellsCmd
      # end
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
      #Death
      case cmd.root
      when "death"
        case cmd.switch
        when "undo"
          return DeathUndoCmd
        end
      end
      #Luck request
      case cmd.root
      when "luck"
        case cmd.switch
        when "request"
          return LuckRequestCmd
        end
      end

      return nil
    end
  end
end
