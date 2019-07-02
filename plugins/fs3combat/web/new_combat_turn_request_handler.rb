module AresMUSH
  module FS3Combat
    class NewCombatTurnRequestHandler
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

        FS3Combat.new_turn(enactor, combat)
                    
        {
        }
      end
    end
  end
end


