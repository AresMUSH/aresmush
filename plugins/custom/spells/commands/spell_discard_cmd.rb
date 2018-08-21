module AresMUSH
  module Custom
    class SpellDiscardCmd
      #spell/discard <spell>
      include CommandHandler
      attr_accessor :spell
      def parse_args
        self.spell = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('custom.not_spell') if !Custom.is_spell?(self.spell)
        return t('custom.dont_know_spell') if !Custom.find_spell_learned(enactor, self.spell)
        return nil
      end


      def handle
        spell_learned = Custom.find_spell_learned(enactor, cmd.args)
        spell_learned.delete
        client.emit_success "You have discarded the #{spell.name} spell."
      end

    end
  end
end
