module AresMUSH
  module Magic
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
        return t('dispatcher.not_allowed') if !enactor.has_permission?("view_bgs")
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return t('magic.already_know_spell', :spell => self.spell) if Magic.find_spell_learned(self.target, self.spell)
        if self.target.groups.values.include? self.school
          return nil
        else
          client.emit t('magic.wrong_school_check', :name => self.target.name)
        end

        return nil

      end

      def handle
        SpellsLearned.create(name: self.spell, last_learned: Time.now, level: self.spell_level, school: self.school, character: target, xp_needed: 0, learning_complete: true)
        client.emit_success t('magic.added_spell', :spell => self.spell, :name => self.target.name)
      end

    end
  end
end
