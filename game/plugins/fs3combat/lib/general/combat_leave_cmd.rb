module AresMUSH
  module FS3Combat
    class CombatLeaveCmd
      include Plugin
      include PluginRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("leave")
      end
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : client.char.name
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|
          combat.leave(self.name)
          combat.save
        end
      end
    end
  end
end