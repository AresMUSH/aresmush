module AresMUSH
  module FS3Combat
    class CombatArmorCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :armor, :specials

      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args( /(?<arg1>[^\=]+)\=(?<arg2>[^\+]+)\+?(?<arg3>.+)?/)
          self.names = list_arg(args.arg1)
          self.armor = titlecase_arg(args.arg2)
          specials_str = titlecase_arg(args.arg3)
        else
          args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
          self.names = [enactor.name]
          self.armor = titlecase_arg(args.arg1)
          specials_str = titlecase_arg(args.arg2)
        end
        
        self.specials = specials_str ? specials_str.split('+') : nil
      end
      
      def required_args
        [ self.names, self.armor ]
      end
      
      def check_valid_armor
        return t('fs3combat.invalid_armor') if !FS3Combat.armor(self.armor)
        return nil
      end
      
      def check_special_allowed
        return nil if !self.specials
        allowed_specials = FS3Combat.armor_stat(self.armor, "allowed_specials") || []
        self.specials.each do |s|
          return t('fs3combat.invalid_armor_special', :special => s) if !allowed_specials.include?(s)
        end
        return nil
      end
      
      
      def handle
        self.names.each do |name|
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
            FS3Combat.set_armor(enactor, combatant, self.armor, self.specials)
          end
        end
      end
    end
  end
end