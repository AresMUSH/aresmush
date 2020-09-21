module AresMUSH
  module Magic
    class SpellModCmd
    #spell/mod <name>=<mod>
      include CommandHandler
      attr_accessor :target_name, :target_combat, :spell_mod, :combat

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.combat = enactor.combat
        self.target_name = args.arg1
        self.target_combat = combat.find_combatant(self.target_name)
        self.spell_mod = trim_arg(args.arg2)
      end

      def check_can_set
        return t('fs3combat.only_organizer_can_do') if self.combat.organizer != enactor
      end

      def check_errors
        return t('magic.invalid_name') if !target_combat
      end

      def handle
        self.target_combat.update(spell_mod: self.gm_spell_mod)
        client.emit_success "You have updated #{target_combat.name}'s spell modification to #{target_combat.gm_spell_mod}."
      end
    end
  end
end
