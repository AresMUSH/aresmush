module AresMUSH
  module Custom
    class SpellAddCmd
      #spell/add <name>=<spell>
      include CommandHandler
      attr_accessor :spell, :spell_list, :school, :spell_level, :target

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.spell = titlecase_arg(args.arg2)
        self.spell_level = Global.read_config("spells", self.spell, "level")
        self.school = Global.read_config("spells", self.spell, "school")
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('db.object_not_found') if !self.target
        return t('custom.not_spell') if !Custom.is_spell?(self.spell)
        if self.target.groups.values.include? self.school
          return nil
        else
          client.emit t('custom.wrong_school_check', :name => self.target.name)
        end
        return t('custom.already_know_spell') if Custom.find_spell_learned(self.target, self.spell)
        return nil

      end

      def handle
        SpellsLearned.create(name: self.spell, last_learned: Time.now, level: self.spell_level, school: self.school, character: target, xp_needed: 0, learning_complete: true)
        client.emit_success t('custom.added_spell', :spell => self.spell, :name => self.target.name)
      end

    end
  end
end
