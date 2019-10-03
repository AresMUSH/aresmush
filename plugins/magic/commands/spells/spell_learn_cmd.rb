module AresMUSH
  module Magic
    class SpellLearnCmd
      #spell/learn <spell>
      include CommandHandler
      attr_accessor :spell, :spell_list, :school, :spell_level

      def parse_args
       self.spell = titlecase_arg(cmd.args)
       self.spell_level = Global.read_config("spells", self.spell, "level")
       self.school = Global.read_config("spells", self.spell, "school")
      end

      def check_errors
        return "What spell do you want to learn?" if !self.spell
        return t('magic.use_school_version') if (self.spell == "Potions" || self.spell == "Familiar")
        return t('magic.request_spell') if (self.spell == "Wild Shape" || self.spell == "Greater Wild Shape" || self.spell == "Half Shift")
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return t('fs3skills.not_enough_xp') if enactor.xp <= 0
        return t('magic.too_many_spells') if Magic.count_spells_total(enactor) >= 30
        return t('magic.need_previous_level') if Magic.previous_level_spell?(enactor, self.spell) == false
        major_school = enactor.group("Major School")
        can_learn_num = FS3Skills.ability_rating(enactor, major_school)
        return t('magic.learning_too_many_spells', :can_learn_num => can_learn_num) if (Magic.count_spells_learning(enactor) > (can_learn_num - 1) && !Magic.find_spell_learned(enactor, self.spell))
        return t('magic.wrong_school') if !enactor.groups.values.include? self.school
        return "Level 8 spells aren't available yet" if self.spell_level == 8
        return nil
      end

      def handle
        spell_learned = Magic.find_spell_learned(enactor, self.spell)
        if spell_learned
          #Gives time in days, if less than 24 hours left, it's learnable
          time_left = (Magic.time_to_next_learn_spell(spell_learned) / 86400)
          if spell_learned.learning_complete
            client.emit_failure t('magic.already_know_spell', :spell => self.spell)
          elsif time_left > 0
            client.emit_failure t('magic.cant_learn_yet', :spell => self.spell, :days => time_left.ceil)
          else
            client.emit_success t('magic.additional_learning', :spell => self.spell)
            xp_needed = spell_learned.xp_needed.to_i - 1
            spell_learned.update(xp_needed: xp_needed)
            spell_learned.update(last_learned: Time.now)
            FS3Skills.modify_xp(enactor, -1)
            if xp_needed < 1
              spell_learned.update(learning_complete: true)
              client.emit_success t('magic.complete_learning', :spell => self.spell)
              message = t('magic.xp_learned_spell', :name => enactor.name, :spell => self.spell, :level => self.spell_level, :school => self.school)
              category = Jobs.system_category
              Jobs.create_job(category, t('magic.xp_learned_spell_title', :name => enactor.name, :spell => self.spell), message, Game.master.system_character)
              Magic.handle_spell_learn_achievement(enactor)
            end
          end
        else
          xp_needed = Magic.spell_xp_needed(self.spell)
          FS3Skills.modify_xp(enactor, -1)
          SpellsLearned.create(name: self.spell, last_learned: Time.now, level: self.spell_level, school: self.school, character: enactor, xp_needed: xp_needed, learning_complete: false)
          client.emit_success t('magic.start_learning', :spell => self.spell)
        end

      end

    end
  end
end
