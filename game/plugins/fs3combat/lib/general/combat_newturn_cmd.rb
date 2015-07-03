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
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        combat = client.char.combatant.combat

        # TODO - initiative order
        combat.combatants.each do |c|
          next if !c.action
          next if c.is_noncombatant?
          messages = c.action.resolve
          messages.each do |m|
            combat.emit m
          end
        end
      end
    end
  end
end