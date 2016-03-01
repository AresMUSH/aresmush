module AresMUSH
  module FS3Combat
    class CombatStopCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
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

        combat.combatants.each do |c|
          c.clear_mock_damage
        end
        
        combat.emit t('fs3combat.combat_stopped_by', :name => client.name)
        client.emit_success t('fs3combat.stopping_combat', :num => self.num)
        
        Global.dispatcher.spawn("Stopping combat.", client) do      
          combat.destroy
          client.emit_success t('fs3combat.combat_stopped', :num => self.num)
        end
      end
    end
  end
end