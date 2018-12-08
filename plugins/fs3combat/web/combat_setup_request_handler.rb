module AresMUSH
  module FS3Combat
    class CombatSetupRequestHandler
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
        
        combatants = {}
        
        combat.active_combatants.select { |c| c.is_npc? }.sort_by { |c| c.name }.each do |c|
          combatants[c.id] = { 
                  id: c.id,
                  team: c.team,
                  name: c.name,
                  weapon: c.weapon_name,
                  weapon_specials: AresMUSH::FS3Combat.weapon_specials.keys.map { |k| {
                    name: k,
                    selected: (c.weapon_specials || []).include?(k)
                  }},
                  armor: c.armor_name,
                  armor_specials: AresMUSH::FS3Combat.armor_specials.keys.map { |k| {
                    name: k,
                    selected: (c.armor_specials || []).include?(k)
                  }},
                  stance: c.stance,
                  npc_skill:  c.npc.level 
              }
            end
            
        {
          id: id,
          organizer: combat.organizer.name,
          can_manage: can_manage,
          combatant_types: FS3Combat.combatant_types.keys,
          combatants: combatants,
          options: {
            weapons: AresMUSH::FS3Combat.weapons.keys,
            weapon_specials: AresMUSH::FS3Combat.weapon_specials.keys,
            armor_specials:  AresMUSH::FS3Combat.armor_specials.keys,
            armor: AresMUSH::FS3Combat.armors.keys,
            stances: FS3Combat.stances.keys,
            npc_skills: FS3Combat.npc_type_names
          }
        }
      end
    end
  end
end


