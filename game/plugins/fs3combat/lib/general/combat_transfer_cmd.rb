module AresMUSH
  module FS3Combat
    class CombatTransferCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress

      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)  
      end
      
      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = enactor.combat
        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.combatant || model.combat != combat)
            client.emit_failure t('fs3combat.must_transfer_to_combatant', :name => self.name)
            return
          end
          
          combat.update(organizer: model)
          combat.emit t('fs3combat.combat_transferred', :name => self.name)
        end
        
      end
    end
  end
end