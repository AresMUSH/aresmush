module AresMUSH
  module FS3Combat
    class JoinCombatRequestHandler
      def handle(request)
        combat_id = request.args['combat_id']
        sender_name = request.args['sender']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        sender = sender_name.blank? ? enactor : Character.named(sender_name)
        combat = Combat[combat_id]
        if (!combat || !sender)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        if (combat.turn_in_progress)
          return { error: t('fs3combat.turn_in_progress') }
        end

        combatant = FS3Combat.join_combat(combat, sender.name, FS3Combat.default_combatant_type, sender, nil)                    
        if (!combatant)
          return { error: t('fs3combat.unable_to_join_combat') }
        end
        
        FS3Combat.build_combat_web_data(combat, enactor)
        
      end
    end
  end
end


