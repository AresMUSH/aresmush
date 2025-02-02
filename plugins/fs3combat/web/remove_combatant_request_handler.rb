module AresMUSH
  module FS3Combat
    class RemoveCombatantRequestHandler
      def handle(request)
        id = request.args['id']
        name = request.args['name']
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('webportal.not_found') }
        end

        combatant = combat.find_combatant(name)
        can_manage = FS3Combat.can_manage_combat?(enactor, combat) || (enactor.name == combatant.name)
        
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


