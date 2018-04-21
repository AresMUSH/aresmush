module AresMUSH
  module FS3Combat
    class UpdateCombatantRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor

        error = WebHelpers.check_login(request)
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

        team = request.args[:team].to_i
        if (team != combatant.team)
          combatant.update(team: team)
          FS3Combat.emit_to_combat combat, t('fs3combat.team_set', :name => combatant.name ), enactor.name
        end
        
        stance = request.args[:stance]
        if (stance != combatant.stance)
          combatant.update(stance: stance)
          FS3Combat.emit_to_combat combat, t('fs3combat.stance_changed', :name => combatant.name, :poss => combatant.poss_pronoun, :stance => stance), enactor.name
        end
        
        weapon = request.args[:weapon]
        selected_weapon_specials = request.args[:weapon_specials] || []
        allowed_specials = FS3Combat.weapon_stat(weapon, "allowed_specials") || []
        weapon_specials = []
        selected_weapon_specials.each do |k, w|
          if (w[:selected].to_bool)
            if (allowed_specials.include?(w[:name]))
              weapon_specials << w[:name]
            else
              return { error: t('fs3combat.invalid_weapon_special', :special => w[:name]) }
            end
          end
        end

        if (combatant.weapon_name != weapon || combatant.weapon_specials != weapon_specials)
          FS3Combat.set_weapon(enactor, combatant, weapon, weapon_specials)
        end
        
        armor = request.args[:armor]
        selected_armor_specials = request.args[:armor_specials] || []
        
        allowed_specials = FS3Combat.armor_stat(armor, "allowed_specials") || []
        armor_specials = []
        selected_armor_specials.each do |k, a|
          if (a[:selected].to_bool)
            if (allowed_specials.include?(a[:name]))
              armor_specials << a[:name]
            else
              return { error: t('fs3combat.invalid_armor_special', :special => a[:name]) }
            end
          end
        end
        
        if (armor != combatant.armor_name || combatant.armor_specials != armor_specials)
          FS3Combat.set_armor(enactor, combatant, armor, armor_specials)
        end
        
        npc = request.args[:npc_skill]
        if (combatant.is_npc? && combatant.npc.level != npc)
          combatant.npc.update(level: npc)
        end
        
        {
        }
      end
    end
  end
end


