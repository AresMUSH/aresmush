module AresMUSH
  module Custom
    class SpellHascastCmd
    #spell/hascast <name>=<true/false>
      include CommandHandler
      attr_accessor :target, :hascast

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.hascast = trim_arg(args.arg2)
      end

      def check_can_use
        combat = FS3Combat.combat(enactor.name)
        return client.emit_failure t('fs3combat.only_organizer_can_do') if (combat.organizer != enactor) if (!enactor.is_admin?)
      end

      def handle
        if self.hascast == "true"
          hascast = true
        elsif self.hascast == "false"
          hascast = false
        end
        self.target.combatant.update(has_cast: hascast)
        client.emit_success "#{target.name}'s has_cast has been set to #{target.combatant.has_cast}."
      end
    end
  end
end
