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
          target_names = args.before("/")
          parse_specials args.after("/").split(",")
        else
          target_names = args
        end
        
        parse_targets target_names
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
      
      # TODO - Check ammo
      # TODO - Check has a weapon
      # TODO - Check not explosive or suppressive
      # TODO - Check enough ammo for burst
      # TODO - Recoil and suppression modifiers
      # TODO - Handle target removed from combat
      # TODO - Clear action when switching weapons
      
      def print_action
        msg = t('fs3combat.attack_action_msg_long', :name => self.name, :target => self.target_names.join(", "))
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
        t('fs3combat.attack_action_msg_short', :target => self.target_names.join(","))
      end
      
      def resolve
        # TODO - Hitting cover
        # TODO - Armor
        # TODO - Ammo - reduce, handle out of ammo situations, alert when out of ammo
        messages = []
        target = targets[0]
        
        if (self.is_burst)
          messages << t('fs3combat.fires_burst', :name => self.name)
          messages << attack_target(target)
          messages << attack_target(target)
          messages << attack_target(target)
        else
          messages << attack_target(target)
        end
        
        messages
      end
      
      def attack_target(target)
        attack_roll = self.combatant.roll_attack(self.mod)
        defense_roll = target.roll_defense(self.combatant.weapon)
        
        if (attack_roll <= 0)
          message = t('fs3combat.attack_missed', :name => self.name, :target => target.name)

        elsif (defense_roll > attack_roll)
          message = t('fs3combat.attack_dodged', :name => self.name, :target => target.name)

        else
          # Margin of success for the attacker
          margin = attack_roll - defense_roll
          
          # Called shot either hits the desired location, or chooses a random location
          # at a penalty for missing.
          if (self.called_shot)
            if (margin > 2)
              hitloc = self.called_shot
            else
              hitloc = target.determine_hitloc(margin - 2)
            end
          else
            hitloc = target.determine_hitloc(margin)
          end
          
          damage = target.determine_damage(hitloc, self.combatant.weapon)
          target.do_damage(damage, self.combatant.weapon, hitloc)
          
          message = t('fs3combat.attack_hits', 
            :name => self.name, 
            :target => target.name,
            :hitloc => hitloc,
            :damage => FS3Combat.display_severity(damage)) 
        end
        message
      end
    end
  end
end