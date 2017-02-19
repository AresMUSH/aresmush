module AresMUSH
  module FS3Combat
    class CombatRandTargetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :number
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.number = cmd.args.arg2 ? cmd.args.arg2.to_i : 1
        else
          self.name = enactor.name
          self.number = cmd.args ? cmd.args.to_i : 1
        end
      end

      def required_args
        {
          args: [ self.name, self.number ],
          help: 'combat'
        }
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