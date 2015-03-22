module AresMUSH
  module FS3Combat
    class CombatLeaveCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("leave")
      end
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : client.char.name
      end

      def handle
        combat = FS3Combat.combat(self.name)
        if (!combat)
          client.emit_failure t('fs3combat.not_in_combat')
          return
        end
        
        combat.leave(self.name)
        combat.save
      end
    end
  end
end