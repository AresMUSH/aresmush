module AresMUSH
  module FS3Combat
    class CombatStopCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if (!combat)

        FS3Combat.emit_to_combat combat, t('fs3combat.combat_stopped_by', :name => enactor_name)
        client.emit_success t('fs3combat.stopping_combat', :num => self.num)
        
        combat.delete
        client.emit_success t('fs3combat.combat_stopped', :num => self.num)
      end
    end
  end
end