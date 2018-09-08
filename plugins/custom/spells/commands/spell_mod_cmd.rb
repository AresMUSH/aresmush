module AresMUSH
  module Custom
    class SpellModCmd
    #spell/mod <name>=<mod>
      include CommandHandler
      attr_accessor :target, :spell_mod

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.spell_mod = trim_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_combat")
      end

      def handle
        self.target.combatant.update(spell_mod: self.spell_mod)
        client.emit_success "You have updated #{target.name}'s spell modification to #{target.combatant.spell_mod}."
      end
    end
  end
end
