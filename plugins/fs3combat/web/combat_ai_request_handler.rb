module AresMUSH
  module FS3Combat
    class CombatAiActionsRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        can_manage = enactor && (enactor == combat.organizer || enactor.is_admin?)
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end        

        if (combat.turn_in_progress)
          return { error: t('fs3combat.turn_in_progress') }
        end

        npcs = combat.active_combatants.select { |c| c.is_npc? && !c.action }
        npcs.each_with_index do |c, i|
          FS3Combat.ai_action(combat, c, enactor)
        end
                    
        {
        }
      end
    end
  end
end


