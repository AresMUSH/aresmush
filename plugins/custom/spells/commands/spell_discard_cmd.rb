module AresMUSH
  module Custom
    class SpellDiscardCmd
      #spell/discard <spell>
      include CommandHandler
      attr_accessor :spell, :spell_learned
      def parse_args
        self.spell = titlecase_arg(cmd.args)
        self.spell_learned = Custom.find_spell_learned(enactor, cmd.args)

      end

      def check_errors
        return t('custom.not_spell') if !Custom.is_spell?(self.spell)
        return t('custom.dont_know_spell') if !Custom.find_spell_learned(enactor, self.spell)
        return t('custom.cant_discard') if !Custom.can_discard?(enactor, self.spell_learned)
        return nil
      end


      def handle
        self.spell_learned.delete
        client.emit_success "You have discarded the #{self.spell_learned.name} spell."
      end

    end
  end
end
