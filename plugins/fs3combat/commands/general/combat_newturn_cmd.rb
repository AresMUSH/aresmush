module AresMUSH
  module FS3Combat
    class CombatNewTurnCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = enactor.combat
        
        if (!FS3Combat.can_manage_combat?(enactor, combat))        
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end
                
        FS3Combat.new_turn(enactor, combat)
      end
    end
  end
end