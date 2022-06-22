module AresMUSH
  module Magic

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("magic-items", item_name)
    end

    def self.item_desc(item)
      Global.read_config("magic-items", item, "desc")
    end

    # def self.item_weapon_specials(char)
    #   item_name = char.magic_item_equipped
    #   if item_name == "None"
    #     nil
    #   else
    #     Global.read_config("magic-items", item_name, "weapon_specials")
    #   end
    # end

    def self.magic_item_weapon_specials(combatant)
      return nil if combatant.npc
      item_name = combatant.associated_model.magic_item_equipped
      return nil if item_name == "None"
      specials =  Global.read_config("magic-items", item_name, "weapon_specials")
      return [specials]
    end

    # def self.magic_item_armor_specials(char)
    #   item_name = char.magic_item_equipped
    #   if item_name == "None"
    #     nil
    #   else
    #     Global.read_config("magic-items", item_name, "armor_specials")
    #   end
    # end

    def self.magic_item_armor_specials(combatant, specials)
      return nil if combatant.npc
      item_name = combatant.associated_model.magic_item_equipped
      return nil if item_name == "None"
      specials =  Global.read_config("magic-items", item_name, "armor_specials")
      return [specials]
    end


    def self.item_spells(char)
      item_name = char.magic_item_equipped || "None"
      if item_name == "None"
        []
      else
        Global.read_config("magic-items", item_name, "spells") || []
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

    def self.item_init_mod(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        0
      else
        Global.read_config("magic-items", item_name, "init_mod")
      end
    end

    def self.get_magic_items(char)
      list = char.magic_items
      list.map { |i|
        {
          name: i,
          desc:  Website.format_markdown_for_html(Magic.item_desc(i))
        }}
    end


  end
end
