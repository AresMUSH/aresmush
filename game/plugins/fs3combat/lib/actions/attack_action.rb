module AresMUSH
  module FS3Combat
    class AttackAction < CombatAction
      include ActionOnlyAllowsSingleTarget
      
      field :mod, :type => Integer
      field :is_burst, :type => Boolean
      field :called_shot, :type => String
      
      def parse_args(args)
        self.is_burst = false
        self.called_shot = nil
        self.mod = 0
        
        if (args =~ /\//)
          names = args.before("/")
          parse_specials args.after("/").split(",")
        else
          names = args
        end
        
        parse_targets names
      end

      def parse_specials(specials)
        specials.each do |s|
          name = s.before(":")
          value = s.after(":")
          case InputFormatter.titleize_input(name)
          when "Called"
            self.called_shot = InputFormatter.titleize_input(value)
          when "Mod"
            self.mod = value.to_i
          when "Burst"
            self.is_burst = true
          else
            raise t('fs3combat.invalid_attack_special')
          end
        end
      end
      
      def check_burst_fire
        return nil if !self.is_burst
        supports_burst = FS3Combat.weapon_stat(self.combatant.weapon, "is_automatic")
        return t('fs3combat.burst_fire_not_allowed') if self.is_burst && !supports_burst
        return nil
      end
      
      def check_called_shot_loc
        return nil if !self.called_shot
        hitlocs = targets[0].hitloc_chart
        return t('fs3combat.invalid_called_shot_loc') if !hitlocs.include?(self.called_shot)
        return nil
      end
      
      def check_ammo
        ammo = self.combatant.ammo
        return nil if !ammo
        return t('fs3combat.not_enough_ammo_for_burst') if self.is_burst && ammo < 2
        return t('fs3combat.out_of_ammo') if ammo == 0
        return nil
      end
      
      def check_weapon_type
        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.use_explode_command') if weapon_type == "Explosive"
        return t('fs3combat.use_suppress_command') if weapon_type == "Suppressive"
        return nil
      end
            
      def print_action
        msg = t('fs3combat.attack_action_msg_long', :name => self.name, :target => print_target_names)
        if (self.is_burst)
          msg << " #{t('fs3combat.attack_special_burst')}"
        end
        if (self.called_shot)
          msg << " #{t('fs3combat.attack_special_called', :location => self.called_shot)}"
        end
        if (self.mod != 0)
          msg << " #{t('fs3combat.attack_special_mod', :mod => self.mod)}"
        end
        msg
      end
      
      def print_action_short
        t('fs3combat.attack_action_msg_short', :target => print_target_names)
      end
      
      def resolve
        messages = []
        target = targets[0]
        
        if (self.is_burst)
          messages << t('fs3combat.fires_burst', :name => self.name)
        end
        
        bullets = self.is_burst ? 3 : 1
        if (self.combatant.ammo && bullets > self.combatant.ammo)
          bullets = self.combatant.ammo
        end
        
        bullets.times.each do |b|
          messages << self.combatant.attack_target(target, self.called_shot, self.mod)
        end

        ammo_message = self.combatant.update_ammo(bullets)
        if (ammo_message)
          messages << ammo_message
        end
        
        messages
      end
    end
  end
end