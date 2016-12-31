module AresMUSH
  module FS3Combat
    class CombatDisembarkCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name

      def crack!
        if (cmd.args)
          self.name = titleize_input(cmd.args)
        else
          self.name = enactor_name
        end
      end

      def required_args
        {
          args: [ self.name ],
          help: 'combat'
        }
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|   
          if (!combatant.is_in_vehicle?)
            client.emit_failure t('fs3combat.not_in_vehicle', :name => self.name)
            return
          end
          FS3Combat.leave_vehicle(combat, combatant)
        end
      end
    end
  end
end