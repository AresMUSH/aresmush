module AresMUSH
  module FS3Combat
    class CombatArmorCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :armor

      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.armor = titlecase_arg(args.arg2)
        else
          self.name = enactor.name
          self.armor = titlecase_arg(cmd.args)
        end
      end
      
      def required_args
        {
          args: [ self.name, self.armor ],
          help: 'combat'
        }
      end
      
      def check_valid_armor
        return t('fs3combat.invalid_armor') if !FS3Combat.armor(self.armor)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          FS3Combat.set_armor(enactor, combatant, self.armor)
        end
      end
    end
  end
end