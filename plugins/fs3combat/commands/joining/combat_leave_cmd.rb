module AresMUSH
  module FS3Combat
    class CombatLeaveCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name      
      
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor.name
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          FS3Combat.leave_combat(combat, combatant)
        end
      end
    end
  end
end