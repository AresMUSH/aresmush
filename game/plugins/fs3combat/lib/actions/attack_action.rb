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
        return nil if ammo.nil?
        return t('fs3combat.not_enough_ammo_for_burst') if self.is_burst && ammo < 2
        return t('fs3combat.out_of_ammo') if ammo == 0
        return nil
      end
      
      # TODO - Check not explosive or suppressive
      # TODO - Recoil and suppression modifiers
      # TODO - Handle target removed from combat
      # TODO - Clear action when switching weapons
      
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
        # TODO - Hitting cover
        # TODO - Armor
        
        if (self.combatant.ammo == 0)
          return [t('fs3combat.weapon_empty', :name => self.name)]
        end
        
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
          messages << attack_target(target)
        end

        update_ammo(bullets)
        
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
      
      def update_ammo(bullets)
        
        if (self.combatant.ammo)
          self.combatant.ammo = self.combatant.ammo - bullets
          
          if (self.combatant.ammo == 0)
            messages << t('fs3combat.weapon_clicks_empty', :name => self.name)
          end

          self.combatant.save
        end
      end
    end
  end
end