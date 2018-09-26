module AresMUSH
  module Tinker
    class ChanceStanceCmd
      include CommandHandler
            
#Gear
      def handle
        enactor.combatant.update(weapon_name: "Club")
        enactor.combatant.update(weapon_specials: "Specials")
        enactor.combatant.update(armor_name: "Tactical")
        enactor.combatant.update(armor_specials: "Tactical")        
      end
        
#Stance
      def handle
        enactor.combatant.update(stance: "Hidden")       
      end
        
#Overall Mods - this may be enactor.combatant or we may have to find the target. So more complicated here. 
      def handle
        combatant.update(defense_mod: self.value)
        combatant.update(damage_lethality_mod: self.value)
        combatant.update(attack_mod: self.value)
      end
      
#Reading the configuration file.
      spell = Global.read_config("spells", "Skipping Stones", "name")      

    end
  end
end
