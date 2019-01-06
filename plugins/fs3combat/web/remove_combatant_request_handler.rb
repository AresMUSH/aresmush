module AresMUSH
  module FS3Combat
    class RemoveCombatantRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        combatant = Combatant[id]
        if (!combatant)
          return { error: t('webportal.not_found') }
        end

        combat = combatant.combat
        can_manage = (enactor == combat.organizer) || enactor.is_admin? || (enactor.name == combatant.name)
        
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end

        FS3Combat.leave_combat(combat, combatant)
        
        {
        }
      end
    end
  end
end


