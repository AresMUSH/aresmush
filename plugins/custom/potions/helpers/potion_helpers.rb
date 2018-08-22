module AresMUSH
  module Custom

    def self.is_potion?(spell)
      spell_name = spell.titlecase
      is_potion = Global.read_config("spells", spell_name, "is_potion")
    end
    
  end
end
