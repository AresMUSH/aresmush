module AresMUSH
  module FS3Combat
    class CombatNewTurnCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("newturn")
      end
      
      def handle
        if (!client.char.is_in_combat?)
          client.emit_failure t('fs3combat.not_in_combat', :name => self.name)
          return
        end
        
        combat = client.char.combatant.combat

        # TODO - initiative order
        combat.combatants.each do |c|
          next if !c.action
          combat.emit c.action.resolve
        end
      end
    end
  end
end