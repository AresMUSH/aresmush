module AresMUSH
  module Custom
    class SpellDiscardCmd
      #spell/discard <spell>
      include CommandHandler

      def handle
        spell = Custom.find_spell_learned(enactor, cmd.args)
        spell.delete
        client.emit_success "You have discarded the #{spell.name} spell."
      end

    end
  end
end
