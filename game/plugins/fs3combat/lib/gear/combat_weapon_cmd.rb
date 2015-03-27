module AresMUSH
  module FS3Combat
    class CombatWeaponCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :weapon, :specials
      
      def initialize
        self.required_args = ['name', 'weapon']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("weapon")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_optional_arg3)
          self.name = titleize_input(cmd.args.arg1)
          self.weapon = titleize_input(cmd.args.arg2)
          specials_str = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_slash_optional_arg2)
          self.name = client.char.name
          self.weapon = titleize_input(cmd.args.arg1)
          specials_str = titleize_input(cmd.args.arg2)
        end
        
        self.specials = specials_str ? specials_str.split(',') : nil
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
        FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
          combatant.weapon = self.weapon
          combatant.weapon_specials = self.specials
          combatant.save
          specials_text = self.specials ? self.specials.join(',') : t('global.none')
          message = t('fs3combat.weapon_changed', :name => self.name, :weapon => self.weapon, :specials => specials_text)
          combat.emit message, FS3Combat.npcmaster_text(self.name, client.char)
        end
      end
    end
  end
end