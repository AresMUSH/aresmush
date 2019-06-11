module AresMUSH
  module Custom
    class SpellLuckCmd
      #spell/luck <spell>
      include CommandHandler
      attr_accessor :spell, :spell_list, :school, :spell_level

      def parse_args
       self.spell = titlecase_arg(cmd.args)
       self.spell_level = Global.read_config("spells", self.spell, "level")
       self.school = Global.read_config("spells", self.spell, "school")
      end

      def check_errors
        return t('fs3skills.not_enough_points') if enactor.luck < 1
        return t('custom.use_school_version') if (self.spell == "Potions" || self.spell == "Familiar")
        return t('custom.not_spell') if !Custom.is_spell?(self.spell)
        return t('custom.need_higher_level', :spell => self.spell) if Custom.higher_level_spell?(enactor, self.spell) == false
        spell_learned = Custom.find_spell_learned(enactor, self.spell)
        return t('custom.only_1_xp_needed') if spell_learned.xp_needed.to_i == 1
        if enactor.groups.values.include? self.school
          return nil
        else
          return t('custom.wrong_school')
        end
        return nil
      end

      def handle
        spell_learned = Custom.find_spell_learned(enactor, self.spell)
        if spell_learned
          if spell_learned.learning_complete
            client.emit_failure t('custom.already_know_spell', :spell => self.spell)
          else
            message = t('custom.reduce_spell_learn_time', :spell => self.spell)

            enactor.spend_luck(2)
            Achievements.award_achievement(enactor, "fs3_luck_spent", 'fs3', "Spent a luck point.")

            job_message = t('custom.reduce_spell_learn_time_job', :name => enactor.name, :spell => self.spell)
            category = Global.read_config("jobs", "luck_category")
            Jobs.create_job(category, t('custom.spent_luck_title', :name => enactor.name, :reason => "reducing the learn time of #{self.spell}."), job_message, enactor)
            Global.logger.info "#{enactor_name} spent luck to reduce the learn time of #{self.spell}."

            new_learn_time = spell_learned.last_learned - 604800
            spell_learned.update(last_learned: new_learn_time)

          end
        else
          client.emit_failure t('custom.not_learning_spell', :spell => self.spell)
        end

      end

    end
  end
end
