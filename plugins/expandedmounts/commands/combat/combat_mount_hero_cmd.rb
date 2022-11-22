module AresMUSH
  module ExpandedMounts
    class CombatMountHeroCmd
      include CommandHandler

      def check_points
        return t('fs3combat.no_luck') if enactor.luck < 1
        return nil
      end

      def check_errors
        return t('exandedmounts.no_mount') if !enactor.bonded
        return t('fs3combat.you_are_not_in_combat') if !enactor.combat
      end


      def handle
        FS3Combat.with_a_combatant(enactor_name, client, enactor) do |combat, combatant|
          if (!combatant.bonded.is_ko)
            client.emit_failure t('expandedmounts.not_koed', :mount => enactor.bonded.name)
            return
          end

          enactor.spend_luck(1)
          Achievements.award_achievement(enactor, "fs3_hero")

          combatant.bonded.update(is_ko: false)
          Magic.death_zero(combatant.bonded)
          wound = FS3Combat.worst_treatable_wound(enactor.bonded)
          if (wound)
            FS3Combat.heal(wound, 1)
          end

          FS3Combat.emit_to_combat combat, t('fs3combat.back_in_the_fight', :name => enactor.bonded.name), nil, true
        end
      end
    end
  end
end