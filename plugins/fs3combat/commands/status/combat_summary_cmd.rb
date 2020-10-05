module AresMUSH
  module FS3Combat
    class CombatSummaryCmd
      include CommandHandler
      
      attr_accessor :filter
      
      def parse_args
        self.filter = cmd.args
      end
        
      def handle
        combat = FS3Combat.combat(enactor.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        if (combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end
        
        template = CombatSummaryTemplate.new(combat, self.filter)
        client.emit template.render
      end
    
    end
  end
end