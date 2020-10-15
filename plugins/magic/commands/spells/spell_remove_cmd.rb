module AresMUSH
  module Magic
    class SpellRemoveCmd
      #spell/remove <name>=<spell>
      include CommandHandler
      attr_accessor :spell, :target, :spell_learned

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.spell = titlecase_arg(args.arg2)
        self.spell_learned = Magic.find_spell_learned(self.target, self.spell)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("view_bgs")
      end

      def check_errors
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return t('magic.dont_know_spell') if !Magic.find_spell_learned(self.target, self.spell)
        return nil
      end

      def handle
        self.spell_learned.delete
        client.emit_success t('magic.removed_spell', :spell => self.spell, :name => self.target.name)
      end

    end
  end
end
