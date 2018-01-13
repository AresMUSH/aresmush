module AresMUSH
  module FS3Combat
    class CombatSummaryRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        if (enactor)
          error = WebHelpers.validate_auth_token(request)
          return error if error
        end
        
        combat = Combat[id]
        if (!combat)
          return { error: "Combat not found." }
        end
        
        teams = combat.active_combatants.sort_by { |c| c.team }
          .group_by { |c| c.team }
          .map { |team, members| 
            { 
              team: team,
              combatants: members.map { |c| 
                {
                  name: c.name,
                  is_ko: c.is_ko,
                  weapon: c.weapon,
                  ammo: c.ammo ? "(#{c.ammo})" : '',
                  damage_boxes: (-c.total_damage_mod).ceil.times.map { |d| d },
                  vehicle: c.vehicle ? "#{c.vehicle.name} #{c.piloting ? 'Pilot' : 'Passenger'}" : "" ,
                  stance: c.stance,
                  action: c.action ? c.action.print_action_short : ""
                }
              }
            }
          }
        
        
        {
          id: id,
          organizer: combat.organizer.name,
          can_manage: enactor && (enactor == combat.organizer || enactor.is_admin?),
          teams: teams
        }
      end
    end
  end
end


