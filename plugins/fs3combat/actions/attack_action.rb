module AresMUSH
  module FS3Combat
    class AttackAction < CombatAction
      
      attr_accessor :mod, :is_burst, :called_shot, :crew_hit, :mount_hit
      
      def prepare
        if (self.action_args =~ /\//)
          names = self.action_args.before("/")
          specials = self.action_args.after("/").split(",")
        else
          names = self.action_args
          specials = []
        end
        
        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.use_explode_command') if weapon_type == "Explosive"
        return t('fs3combat.use_suppress_command') if weapon_type == "Suppressive"
        
        error = self.parse_targets(names)
        return error if error
      
        return t('fs3combat.only_one_target') if (self.targets.count > 1)
      
        self.is_burst = false
        self.called_shot = nil
        self.mod = 0
        self.crew_hit = false
        self.mount_hit = false
                
        error = self.parse_specials(specials)
        return error if error
        
        supports_burst = FS3Combat.weapon_stat(self.combatant.weapon, "is_automatic")
        return t('fs3combat.burst_fire_not_allowed') if self.is_burst && !supports_burst
        
        return t('fs3combat.no_fullauto_called_shots') if self.called_shot && self.is_burst
        
        return t('fs3combat.invalid_called_shot_loc') if self.called_shot && !FS3Combat.has_hitloc?(target, self.called_shot)
        
        return t('fs3combat.out_of_ammo') if !FS3Combat.check_ammo(self.combatant, 1)
        return t('fs3combat.not_enough_ammo_for_burst') if self.is_burst && !FS3Combat.check_ammo(self.combatant, 2)
        
        return nil
      end

      def parse_specials(specials)
        specials.each do |s|
          name = s.before(":")
          value = s.after(":")
          case InputFormatter.titlecase_arg(name)
          when "Called"
            self.called_shot = InputFormatter.titlecase_arg(value)
          when "Mod"
            self.mod = value.to_i
          when "Burst"
            self.is_burst = true
          when "Crew"
            self.crew_hit = true
          when "Mount"
            self.mount_hit = true
          else
            return t('fs3combat.invalid_attack_special')
          end
        end
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
        if (self.crew_hit)
          msg << " #{t('fs3combat.attack_special_crew')}"
        end
        if (self.mount_hit)
          msg << " #{t('fs3combat.attack_special_mount')}"
        end
        
        msg
      end
      
      def print_action_short
        specials = self.action_args.after("/")
        t('fs3combat.attack_action_msg_short', :target => print_target_names, :specials => specials)
      end
      
      def resolve
        messages = []
        
        if (self.is_burst)
          messages << t('fs3combat.fires_burst', :name => self.name)
        end
        
        bullets = self.is_burst ? [3, self.combatant.ammo].min : 1
        bullets.times.each do |b|
          messages.concat FS3Combat.attack_target(combatant, target, self.mod, self.called_shot, self.crew_hit, self.mount_hit)
        end

        ammo_message = FS3Combat.update_ammo(combatant, bullets)
        if (ammo_message)
          messages << ammo_message
        end
        
        messages
      end
    end
  end
end