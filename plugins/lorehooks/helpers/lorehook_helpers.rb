module AresMUSH
  module Lorehooks

    def self.lore_hook_type(char)
      if char.lore_hook_type == "Item"
        item = char.lore_hook_name ? true : false
      elsif char.lore_hook_type == "Pet"
        pet = char.lore_hook_name ? char.lore_hook_name.gsub(" Pet","") : false
      elsif char.lore_hook_type == "Ancestry"
        ancestry = char.lore_hook_name ? char.lore_hook_name.gsub(" Ancestry","") : false
      end

      return {
        item: item,
        pet: pet,
        ancestry: ancestry 
      }
    end

    def self.lore_hook_cg_prefs
      lore_hook_config = Global.read_config('lorehooks', 'lore_hook_prefs')
      lore_hook_prefs = []
      lore_hook_config.each do |k, v|
        lore_hook_prefs << { desc: v, value: k }
      end
      return lore_hook_prefs
    end

  end
end
