module AresMUSH
  module FS3Combat
    class AddCombatantRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        combatant_type = request.args[:combatant_type] || FS3Combat.default_combatant_type
        names = (request.args[:name] || "").split(/[ ,]/)
        
        if (names.empty?)
          return { error: t('fs3combat.invalid_combatant_name')}
        end
        
        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        names.each do |name|
          if (name.blank?)
            next
          end
          
          if (FS3Combat.is_in_combat?(name))
            return { error: t('fs3combat.already_in_combat', :name => name) }
          end
        
          combatant = FS3Combat.join_combat(combat, name, combatant_type, enactor, nil)
          if (!combatant) 
            return { error: t('fs3combat.already_in_combat', :name => name) }
          end
        end
        
        FS3Combat.build_combat_web_data(combat, enactor)
      end
    end
  end
end


