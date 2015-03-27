module AresMUSH
  module FS3Combat
    class CombatHitlocsCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("hitlocs")
      end
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : client.char.name
      end

      def handle
        FS3Combat.with_a_combatant(name, client) do |combat, combatant|
          # TODO - If combatant is pilot or passenger, use their vehicle's hitloc chart
          hitlocs = FS3Combat.hitloc("Humanoid")["default"].uniq
          client.emit BorderedDisplay.list hitlocs.sort, t('fs3combat.hitlocs_for', :name => self.name)
        end
      end
    end
  end
end