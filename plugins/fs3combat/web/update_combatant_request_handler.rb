module AresMUSH
  module FS3Combat
    class UpdateCombatantRequestHandler
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
        can_manage = FS3Combat.can_manage_combat?(enactor, combat) || (enactor.name == combatant.name)
        
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end

        if (combat.turn_in_progress)
          return { error: t('fs3combat.turn_in_progress') }
        end

        team = request.args[:team].to_i
        stance = request.args[:stance]
        weapon = request.args[:weapon]
        action = request.args[:action] || "pass"
        if (action.blank?)
          action = "pass"
        end
        action_args = (request.args[:action_args] || "").strip
        selected_weapon_specials = (request.args[:weapon_specials] || [])
           .select { |k, w| (w[:selected] || "").to_bool }
            .map { |k, w| w[:name] }
        armor = request.args[:armor]
        selected_armor_specials = (request.args[:armor_specials] || [])
          .select { |k, a| (a[:selected] || "").to_bool }
          .map { |k, a| a[:name] }
        npc_level = request.args[:npc_skill]
        vehicle = request.args[:vehicle] || ''
        passenger_type = request.args[:passenger_type] || 'none'
        
        error = FS3Combat.update_combatant(combat, combatant, enactor, team, stance, weapon, selected_weapon_specials, armor, selected_armor_specials, npc_level, action, action_args, vehicle, passenger_type)
        
        if (error)
          return { error: error }
        end
        
        {
        }
      end
    end
  end
end


