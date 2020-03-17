module AresMUSH
  module Magic
    class SpellDiscardCmd
      #spell/discard <spell>
      include CommandHandler
      attr_accessor :spell, :spell_learned
      def parse_args
        self.spell = titlecase_arg(cmd.args)
        self.spell_learned = Magic.find_spell_learned(enactor, self.spell)

      end

      def check_errors
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return t('magic.dont_know_spell') if !Magic.find_spell_learned(enactor, self.spell)
        return t('magic.cant_discard') if !Magic.can_discard?(enactor, self.spell_learned)
        return nil
      end


      def handle
        self.spell_learned.delete
        client.emit_success t('magic.discarded_spell', :spell => self.spell)
        Magic.handle_spell_discard_achievement(enactor)
      end

    end
  end
end
