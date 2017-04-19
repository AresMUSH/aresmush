module AresMUSH
  module FS3Combat
    class CombatStanceCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :stance
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.stance = titlecase_arg(args.arg2)
        else
          self.name = enactor.name
          self.stance = titlecase_arg(cmd.args)
        end
        
        self.stance = self.stances.select { |s| s.start_with? self.stance }.first
      end

      def required_args
        {
          args: [ self.name, self.stance ],
          help: 'combat'
        }
      end

      def stances
        ['Aggressive', 'Normal', 'Defensive', 'Evade', 'Cover', 'Hidden']
      end
      
      def check_stance        
        return t('fs3combat.invalid_stance') if !stances.include?(self.stance)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          combatant.update(stance: stance)
          message = t('fs3combat.stance_changed', :stance => self.stance, :name => self.name, :poss => combatant.poss_pronoun)
          combat.emit message, FS3Combat.npcmaster_text(name, enactor)
        end
      end
    end
  end
end