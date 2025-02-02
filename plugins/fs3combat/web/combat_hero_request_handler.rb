module AresMUSH
  module FS3Combat
    class CombatHeroRequestHandler
      def handle(request)
        combat_id = request.args['combat_id']
        sender_name = request.args['sender']
        command_text = request.args['command']
        enactor = request.enactor
                
        error = Website.check_login(request)
        return error if error
        
        sender = sender_name.blank? ? enactor : Character.named(sender_name)
        combat = Combat[combat_id]
        if (!combat || !sender)
          return { error: t('webportal.not_found') }
        end
        
        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (sender.combat != combat)
           return { error: t('fs3combat.you_are_not_in_combat') }
        end
         
        combatant = sender.combatant
        if (!combatant.is_ko)
          return { error: t('fs3combat.not_koed') }
        end

        if (sender.luck < 1) 
          return { error: t('fs3combat.no_luck') }
        end
        
        sender.spend_luck(1)
        Achievements.award_achievement(sender, "fs3_hero")
        
        combatant.update(is_ko: false)
        wound = FS3Combat.worst_treatable_wound(sender)
        if (wound)
          FS3Combat.heal(wound, 1)
        end
        
        FS3Combat.emit_to_combat combat, t('fs3combat.back_in_the_fight', :name => sender.name), nil, true
            

       FS3Combat.build_combat_web_data(combat, enactor)
      end
    end
  end
end


