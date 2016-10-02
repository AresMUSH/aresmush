module AresMUSH
  module FS3Combat
    class CombatWeaponCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :weapon, :specials
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_optional_arg3)
          self.name = titleize_input(cmd.args.arg1)
          self.weapon = titleize_input(cmd.args.arg2)
          specials_str = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_slash_optional_arg2)
          self.name = enactor.name
          self.weapon = titleize_input(cmd.args.arg1)
          specials_str = titleize_input(cmd.args.arg2)
        end
        
        self.specials = specials_str ? specials_str.split(',') : nil
      end

      def required_args
        {
          args: [ self.name, self.weapon ],
          help: 'combat'
        }
      end
      
      def check_special_allowed
        return nil if !self.specials
        allowed_specials = FS3Combat.weapon_stat(self.weapon, "allowed_specials")
        self.specials.each do |s|
          return t('fs3combat.invalid_weapon_special') if !allowed_specials.include?(s)
        end
        return nil
      end
      
      def check_valid_weapon
        return t('fs3combat.invalid_weapon') if !FS3Combat.weapon(self.weapon)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          FS3Combat.set_weapon(enactor, combatant, self.weapon, self.specials)
        end
      end
    end
  end
end