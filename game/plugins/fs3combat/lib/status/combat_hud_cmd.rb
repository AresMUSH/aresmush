module AresMUSH
  module FS3Combat
    class CombatHudCmd
      include CommandHandler
      
      def handle
        combat = FS3Combat.combat(enactor.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        template = CombatHudTemplate.new(combat)
        client.emit template.render
      end
    end
  end
end