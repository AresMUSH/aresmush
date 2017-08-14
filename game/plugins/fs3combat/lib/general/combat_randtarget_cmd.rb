module AresMUSH
  module FS3Combat
    class CombatRandTargetCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :number
      
      def parse_args
        # name=number for NPC
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = titlecase_arg(args.arg1)
          self.number = args.arg2 ? integer_arg(args.arg2) : 1
        # No arg - for PC
        elsif (!cmd.args)
          self.name = enactor.name
          self.number = 1
        # Single arg - could be a name or a number.
        else
          
          self.number = integer_arg(cmd.args)

          if (self.number == 0)
            self.name = titlecase_arg(cmd.args)
            self.number = 1
          else
            self.name = enactor.name
            self.number = integer_arg(cmd.args)
          end
        end
      end

      def required_args
        [ self.name, self.number ]
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          
          targets = []
          self.number.times.each do |n|
            target = FS3Combat.find_ai_target(combat, combatant)
            if (target)
              targets << target.name
            end
          end
          
          client.emit_ooc t('fs3combat.random_targets', :targets => targets.join(" "))          
        end
      end
    end
  end
end