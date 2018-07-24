module AresMUSH
  module FS3Combat
    class GetCombatantRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]

        combatant_type = request.args[:combatant_type] || FS3Combat.default_combatant_type
        
        error = Website.check_login(request)
        return error if error
        
        combatant = Combatant[id]
        if (!combatant)
          return { error: t('webportal.not_found') }
        end
        
        can_manage = (enactor == combatant.combat.organizer) || enactor.is_admin? || (enactor.name == combatant.name)
        
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end
          
        {
          id: combatant.id,
          name: combatant.name,
          combatant_type: combatant.combatant_type,
          weapon: combatant.weapon_name,
          weapon_specials: AresMUSH::FS3Combat.weapon_specials.keys.map { |k| {
            name: k,
            selected: (combatant.weapon_specials || []).include?(k)
          }},
          armor: combatant.armor_name,
          armor_specials: AresMUSH::FS3Combat.armor_specials.keys.map { |k| {
            name: k,
            selected: (combatant.armor_specials || []).include?(k)
          }},
          stance: combatant.stance,
          team: combatant.team,
          npc_skill: combatant.is_npc? ? combatant.npc.level : nil,
          combat: combatant.combat.id,
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


