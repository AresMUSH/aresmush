$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Magic

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("magic", "shortcuts")
    end

    def self.achievements
      Global.read_config('magic', 'achievements')
    end

    def self.get_cmd_handler(client, cmd, enactor)

      #ITEMS
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

      #POTIONS
      case cmd.root
      when "potions"
        return PotionsCmd
      end
      case cmd.root
      when "potion"
        case cmd.switch
        when "create"
          return PotionCreateCmd
        when "update"
          return PotionUpdateCmd
        when "give"
          return PotionGiveCmd
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
        when "request"
          return SpellRequestCmd
        when "mod"
          return SpellModCmd
        when "modis"
          return SpellModIsCmd
        when "cast"
          return SpellCastCmd
        when "npc"
          return SpellNPCCmd
        when "learn"
          return SpellLearnCmd
        when "luck"
          return SpellLuckCmd
        when "discard"
          return SpellDiscardCmd
        when "add"
          return SpellAddCmd
        when "remove"
          return SpellRemoveCmd
        when "search"
          return SpellSearchCmd
        when "hascast"
          return SpellHascastCmd
        end
        return SpellDetailCmd
      end

      case cmd.root
      when "spells"
        return SpellsCmd
      end

      case cmd.root
      when "shield"
        case cmd.switch
        when "off"
          return ShieldOffCmd
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
      when "searchSpells"
        return SearchSpellsRequestHandler
      when "getSpellDamage"
        return GetSpellDamageRequestHandler     
      when "getSpellEffects"
        return GetSpellEffectsRequestHandler
      when "getSchools"
        return GetSchoolsRequestHandler
      when "addSceneSpell"
        return AddSceneSpellRequestHandler
      when "charSpells"
        return CharSpellsRequestHandler
      end
      nil
    end

  end
end
