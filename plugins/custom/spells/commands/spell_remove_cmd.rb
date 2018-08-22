module AresMUSH
  module Custom
    class SpellRemoveCmd
      #spell/remove <name>=<spell>
      include CommandHandler
      attr_accessor :spell, :target, :spell_learned

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.spell = titlecase_arg(args.arg2)
        self.spell_learned = Custom.find_spell_learned(self.target, self.spell)
      end

      def check_errors
        return t('custom.not_spell') if !Custom.is_spell?(self.spell)
        return t('custom.dont_know_spell') if !Custom.find_spell_learned(self.target, self.spell)
        return nil
      end

      def handle
        self.spell_learned.delete
        client.emit_success t('custom.removed_spell', :spell => self.spell, :name => self.target.name)
      end

    end
  end
end
