module AresMUSH
  module FS3Combat
    class CombatStopCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :num
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("stop")
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if (!combat)

        combat.emit t('fs3combat.combat_stopped_by', :name => client.name)
        combat.destroy
        
        client.emit_success t('fs3combat.combat_stopped', :num => self.num)
      end
    end
  end
end