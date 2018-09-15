module AresMUSH
  module Custom
    class SpellModCmd
    #spell/mod <name>=<mod>
      include CommandHandler
      attr_accessor :target_name, :target_combat, :spell_mod

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        combat = enactor.combat
        self.target_name = args.arg1
        self.target_combat = combat.find_combatant(self.target_name)
        self.spell_mod = trim_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_combat")
      end

      def check_errors
        return t('custom.invalid_name') if !target_combat
      end

      def handle
        self.target_combat.update(spell_mod: self.spell_mod)
        client.emit_success "You have updated #{target_combat.name}'s spell modification to #{target_combat.spell_mod}."
      end
    end
  end
end
