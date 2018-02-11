module AresMUSH
  module FS3Combat
    class CombatDisembarkCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name

      def parse_args
        if (cmd.args)
          self.name = titlecase_arg(cmd.args)
        else
          self.name = enactor_name
        end
      end

      def required_args
        [ self.name ]
      end
      
      def check_vehicles_allowed
        return t('fs3combat.vehicles_disabled') if !FS3Combat.vehicles_allowed?
        return nil
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