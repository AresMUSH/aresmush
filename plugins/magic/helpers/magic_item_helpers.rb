module AresMUSH
  module Magic

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("magic-items", item_name)
    end

    def self.item_desc(item)
      Global.read_config("magic-items", item, "desc")
    end

    def self.item_weapon_specials(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        nil
      else
        Global.read_config("magic-items", item_name, "weapon_specials")
      end
    end

    def self.set_magic_item_weapon_specials(combatant, specials)
      if !combatant.npc
        item_specials = Magic.item_weapon_specials(combatant.associated_model)
      else
        item_specials = nil
      end

      if !combatant.npc && combatant.associated_model.magic_item_equipped && specials && item_specials
        specials.concat [item_specials]
      elsif !combatant.npc && combatant.associated_model.magic_item_equipped && item_specials
        specials = [item_specials]
      end
      return specials
    end

    def self.item_armor_specials(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        nil
      else
        Global.read_config("magic-items", item_name, "armor_specials")
      end
    end

    def self.set_magic_item_armor_specials(combatant, specials)
      if !combatant.npc
        item_specials = Magic.item_armor_specials(combatant.associated_model)
      end
      if !combatant.npc && specials && combatant.associated_model.magic_item_equipped && item_specials
        specials.concat [item_specials]
      elsif !combatant.npc && combatant.associated_model.magic_item_equipped && item_specials
        specials = [item_specials]
      else
        specials = nil
      end
      return specials
    end


    def self.item_spell(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        nil
      else
        item = self.find_item(char, item_name)
        item.spell
      end
    end

    def self.item_spell_mod(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        0
      else
        Global.read_config("magic-items", item_name, "spell_mod")
      end
    end

    def self.item_attack_mod(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        0
      else
        Global.read_config("magic-items", item_name, "attack_mod")
      end
    end

  end
end
