module AresMUSH
  module FS3Combat
    class CombatWeaponCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      attr_accessor :name, :weapon, :specials

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)\+?(?<arg3>.+)?/)

          self.name = titlecase_arg(args.arg1)
          self.weapon = titlecase_arg(args.arg2)
          specials_str = titlecase_arg(args.arg3)
        else
          args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
                               
          self.name = enactor.name
          self.weapon = titlecase_arg(args.arg1)
          specials_str = titlecase_arg(args.arg2)
        end

        self.specials = specials_str ? specials_str.split('+') : nil
        client.emit self.name
        client.emit self.weapon
        client.emit specials_str
      end

      def required_args
        [ self.name, self.weapon ]
      end

      def check_special_allowed
        return nil if !self.specials
        special_group = FS3Combat.weapon_stat(weapon, "special_group") || ""
        allowed_specials = Global.read_config("fs3combat", "weapon special groups", special_group) || []
        self.specials.each do |s|
          return t('fs3combat.invalid_weapon_special') if !allowed_specials.include?(s.downcase)
        end
        return nil
      end

      def check_valid_weapon
        return t('fs3combat.invalid_weapon') if !FS3Combat.weapon(self.weapon)
        return t('custom.cast_to_use') if Custom.is_magic_gear(self.weapon)
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
