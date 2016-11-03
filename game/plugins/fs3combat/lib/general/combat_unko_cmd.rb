module AresMUSH
  module FS3Combat
    class CombatUnkoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'combat org'
        }
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          if (combat.organizer != enactor)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end

          combatant.update(is_ko: false)
          client.emit_success t('fs3combat.is_no_longer_koed', :name => self.name)
        end
      end
    end
  end
end