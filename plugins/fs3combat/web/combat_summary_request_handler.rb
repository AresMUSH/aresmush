module AresMUSH
  module FS3Combat
    class CombatSummaryRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        can_manage = enactor && (enactor == combat.organizer || enactor.is_admin?)
        
        teams = combat.active_combatants.sort_by { |c| c.team }
          .group_by { |c| c.team }
          .map { |team, members| 
            { 
              team: team,
              combatants: members.map { |c| 
                {
                  id: c.id,
                  name: c.name,
                  is_ko: c.is_ko,
                  weapon: c.weapon,
                  armor: c.armor,
                  ammo: c.ammo ? "(#{c.ammo})" : '',
                  damage_boxes: (-c.total_damage_mod).ceil.times.map { |d| d },
                  vehicle: c.vehicle ? "#{c.vehicle.name} #{c.piloting ? 'Pilot' : 'Passenger'}" : "" ,
                  stance: c.stance,
                  action: c.action ? c.action.print_action_short : "",
                  can_edit: can_manage || (enactor && enactor.name == c.name)
                }
              }
            }
          }
        
        
        {
          id: id,
          organizer: combat.organizer.name,
          can_manage: can_manage,
          combatant_types: FS3Combat.combatant_types.keys,
          teams: teams
        }
      end
    end
  end
end


