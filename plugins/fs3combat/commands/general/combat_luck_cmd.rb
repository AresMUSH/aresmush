module AresMUSH
  module FS3Combat
    class CombatLuckCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      attr_accessor :reason

      def parse_args
        self.reason = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.reason ]
      end

      def check_reason
        reasons = ["Initiative", "Attack", "Defense", "Spell"]
        return t('fs3combat.invalid_luck', :reasons => reasons.join(", ")) if !reasons.include?(self.reason)
        return nil
      end

      def handle
        FS3Combat.with_a_combatant(enactor_name, client, enactor) do |combat, combatant|

          if (!combatant.luck)
            if (enactor.luck >= 1)
              enactor.spend_luck(1)
              Achievements.award_achievement(enactor, "fs3_luck_spent")
            else
              client.emit_failure t('fs3combat.no_luck')
              return
            end
          end
          job_message = t('custom.spent_luck', :name => enactor.name, :reason => self.reason)
          category = Global.read_config("jobs", "luck_category")
          Jobs.create_job(category, t('custom.spent_luck_title', :name => enactor.name, :reason => "combat: #{self.reason}"), job_message, enactor)

          combatant.update(luck: self.reason)

          FS3Combat.emit_to_combat combat, t('fs3combat.spending_luck', :name => enactor_name, :reason => self.reason)
        end
      end
    end
  end
end
