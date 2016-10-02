module AresMUSH
  module FS3Combat
    class CombatArmorCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :armor

      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.armor = titleize_input(cmd.args.arg2)
        else
          self.name = enactor.name
          self.armor = titleize_input(cmd.args)
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
          FS3Combat.set_armor(client, combatant, self.armor)
        end
      end
    end
  end
end