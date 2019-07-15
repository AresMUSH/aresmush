module AresMUSH
  module FS3Combat
    class SaveCombatTeamsRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        if (combat.turn_in_progress)
          return { error: t('fs3combat.turn_in_progress') }
        end

        combatants = request.args[:combatants]
        combatants.each do |key, combatant_data|
          
          combatant = Combatant[combatant_data[:id]]
          
          if (!combatant)
            return { error: t('fs3combat.not_in_combat', :name => combatant_data[:name])}
          end
          
          team = combatant_data[:team].to_i
          
          if (team != combatant.team)
            FS3Combat.change_team(combat, combatant, enactor, team)
          end
          
        
          if (error)
            return { error: "Error saving #{combatant.name}: #{error}" }
          end
        end
                    
        {
        }
      end
    end
  end
end


