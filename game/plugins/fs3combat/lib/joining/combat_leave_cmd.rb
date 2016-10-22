module AresMUSH
  module FS3Combat
    class CombatLeaveCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name      
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : enactor.name
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          FS3Combat.leave_combat(combat, combatant)
        end
      end
    end
  end
end