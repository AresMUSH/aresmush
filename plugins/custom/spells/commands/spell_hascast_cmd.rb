module AresMUSH
  module Custom
    class SpellHascastCmd
    #spell/hascast <name>=<true/false>
      include CommandHandler
      attr_accessor :target, :hascast

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        combat = enactor.combat
        self.target = combat.find_combatant(args.arg1)
        self.hascast = trim_arg(args.arg2)
      end

      def handle
        if self.hascast == "true"
          hascast = true
        elsif self.hascast == "false"
          hascast = false
        end
        self.target.update(has_cast: hascast)
        client.emit_success "#{target.name}'s has_cast has been set to #{target.has_cast}."
      end
    end
  end
end
