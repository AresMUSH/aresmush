module AresMUSH
  module FS3Combat
    class CombatIdleCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          if (combat.organizer != enactor)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end

          if (combatant.idle)
            combatant.update(idle: false)
            client.emit_success t('fs3combat.marked_unidle', :name => self.name)
          else
            combatant.update(idle: true)
            client.emit_success t('fs3combat.marked_idle', :name => self.name)
          end
        end
      end
    end
  end
end