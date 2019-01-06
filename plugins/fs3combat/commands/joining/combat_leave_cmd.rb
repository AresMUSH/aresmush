module AresMUSH
  module FS3Combat
    class CombatLeaveCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names    
      
      def parse_args
        self.names = cmd.args ? list_arg(cmd.args) : [enactor.name]
      end

      def handle
        self.names.each do |name|
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|
            FS3Combat.leave_combat(combat, combatant)
          end
        end
      end
    end
  end
end