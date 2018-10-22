module AresMUSH
  module Custom

    def self.is_item?(item)
      item_name = item.titlecase
      is_item = Global.read_config("magic-items", item_name)
    end

    def self.find_item (char, item_name)
      char.magic_items.select { |a| a.name == item_name }.first
    end

    def self.item_weapon_specials(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        nil
      else
        item = self.find_item(char, item_name)
        item.weapon_specials
      end
    end

    def self.item_armor_specials(char)
      item_name = char.magic_item_equipped
      if item_name == "None"
        nil
      else
        item = self.find_item(char, item_name)
        item.armor_specials
      end
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
        item = self.find_item(char, item_name)
        item.item_spell_mod
      end
    end

  end
end
