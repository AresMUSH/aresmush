module AresMUSH
  module FS3Combat
    class AddCombatantRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        combatant_type = request.args[:combatant_type] || FS3Combat.default_combatant_type
        name = request.args[:name]
        
        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        if (FS3Combat.is_in_combat?(name))
          return { error: t('fs3combat.already_in_combat', :name => name) }
        end
        
        FS3Combat.join_combat(combat, name, combatant_type, enactor, nil)
        
        
        {
        }
      end
    end
  end
end


