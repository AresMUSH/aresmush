module AresMUSH
  module Magic
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
        return t('magic.use_school_version') if (self.spell == "Potions" || self.spell == "Familiar")
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return t('magic.need_higher_level', :spell => self.spell) if Magic.higher_level_spell?(enactor, self.spell) == false
        spell_learned = Magic.find_spell_learned(enactor, self.spell)
        return t('magic.only_1_xp_needed') if spell_learned.xp_needed.to_i == 1
        if enactor.groups.values.include? self.school
          return nil
        else
          return t('magic.wrong_school')
        end
        return nil
      end

      def handle
        spell_learned = Magic.find_spell_learned(enactor, self.spell)
        if spell_learned
          if spell_learned.learning_complete
            client.emit_failure t('magic.already_know_spell', :spell => self.spell)
          else
            message = t('magic.reduce_spell_learn_time', :spell => self.spell)

            enactor.spend_luck(2)
            Achievements.award_achievement(enactor, "fs3_luck_spent", 'fs3', "Spent a luck point.")

            job_message = t('magic.reduce_spell_learn_time_job', :name => enactor.name, :spell => self.spell)
            category = Global.read_config("jobs", "luck_category")
            Jobs.create_job(category, t('fs3skills.luck_point_spent', :reason => "learn time of #{self.spell}."), job_message, enactor)
            Global.logger.info "#{enactor_name} spent luck to reduce the learn time of #{self.spell}."
            client.emit_success job_message

            new_learn_time = spell_learned.last_learned - 604800
            spell_learned.update(last_learned: new_learn_time)

          end
        else
          client.emit_failure t('magic.not_learning_spell', :spell => self.spell)
        end

      end

    end
  end
end
