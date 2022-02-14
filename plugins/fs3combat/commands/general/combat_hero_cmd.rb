module AresMUSH
  module FS3Combat
    class CombatHeroCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      
      def check_points
        return t('fs3combat.no_luck') if enactor.luck < 1
        return nil
      end
    
      
      def handle
        FS3Combat.with_a_combatant(enactor_name, client, enactor) do |combat, combatant|
          if (!combatant.is_ko)
            client.emit_failure t('fs3combat.not_koed')
            return
          end
          
          enactor.spend_luck(1)
          Achievements.award_achievement(enactor, "fs3_hero")
          
          combatant.update(is_ko: false)
          wound = FS3Combat.worst_treatable_wound(enactor)
          if (wound)
            FS3Combat.heal(wound, 1)
          end
          
          FS3Combat.emit_to_combat combat, t('fs3combat.back_in_the_fight', :name => enactor_name), nil, true
        end
      end
    end
  end
end