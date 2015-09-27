module AresMUSH
  module FS3Combat
    class CombatAiCmd
      include Plugin
      include PluginRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("ai")
      end
      
      
      def handle
        combat = FS3Combat.combat(client.char.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        if (combat.organizer != client.char)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        combat.active_combatants.select { |c| c.is_npc? }.each_with_index do |c, i|
          Global.dispatcher.queue_timer(i, "Combat AI") do          
            combat.ai_action(client, c)
          end
        end
      end
    end
  end
end