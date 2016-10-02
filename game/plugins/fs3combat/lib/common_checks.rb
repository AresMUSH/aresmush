module AresMUSH
  module FS3Combat
    
    module NotAllowedWhileTurnInProgress
      def check_turn_in_progress
        combatant = enactor.combatant
        combat =  combatant ? combatant.combat : nil
        return nil if !combat
        return t('fs3combat.turn_in_progress') if combat.turn_in_progress
        return nil
      end
    end
  end
end