module AresMUSH
  module FS3Combat
    class CombatAiCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("ai")
      end
      
      
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !client.char.is_in_combat?
        return nil
      end
      
      def handle
        combat = client.char.combatant.combat
        
        if (combat.organizer != client.char)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        npcs = combat.active_combatants.select { |c| c.is_npc? && !c.action }
        
        if (npcs.empty?)
          client.emit_failure t('fs3combat.no_ai_actions_to_set')
          return
        end
        
        client.emit_success t('fs3combat.choosing_ai_actions')
        
        npcs.each_with_index do |c, i|
          Global.dispatcher.queue_timer(i, "Combat AI", client) do  
            combat.ai_action(client, c)
          end
        end
      end
    end
  end
end