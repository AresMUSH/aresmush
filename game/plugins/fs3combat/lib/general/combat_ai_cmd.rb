module AresMUSH
  module FS3Combat
    class CombatAiCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :force
      
      def crack!
       self.force = (cmd.args && cmd.args.downcase == "force")
     end
     
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        combat = enactor.combat
        
        if (combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        if (self.force)
          npcs = combat.active_combatants.select { |c| c.is_npc? }
        else
          npcs = combat.active_combatants.select { |c| c.is_npc? && !c.action }
        end
        
        if (npcs.empty?)
          client.emit_failure t('fs3combat.no_ai_actions_to_set')
          return
        end
        
        client.emit_success t('fs3combat.choosing_ai_actions')
        
        npcs.each_with_index do |c, i|
          FS3Combat.ai_action(combat, client, c)
        end
      end
    end
  end
end