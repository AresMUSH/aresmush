module AresMUSH
  module FS3Combat
    class CombatHeroRequestHandler
      def handle(request)
        combat_id = request.args[:combat_id]
        combatant_id = request.args[:combatant_id]
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        combat = Combat[combat_id]
        combatant = Combatant[combatant_id]
        if (!combat || !combatant)
          return { error: t('webportal.not_found') }
        end

        if (combatant.combat != combat)
           return { error: t('fs3combat.you_are_not_in_combat') }
         end
         
        if (!combatant.is_ko)
          return { error: t('fs3combat.not_koed') }
        end

        if (enactor.luck < 1) 
          return { error: t('fs3combat.no_luck') }
        end
        
        enactor.spend_luck(1)
        Achievements.award_achievement(enactor, "fs3_hero")
        
        combatant.update(is_ko: false)
        wound = FS3Combat.worst_treatable_wound(enactor)
        if (wound)
          FS3Combat.heal(wound, 1)
        end
        
        FS3Combat.emit_to_combat combat, t('fs3combat.back_in_the_fight', :name => enactor.name), nil, true
            

       FS3Combat.build_combat_web_data(combat, enactor)
      end
    end
  end
end


