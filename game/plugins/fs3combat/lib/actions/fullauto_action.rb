module AresMUSH
  module FS3Combat
    class FullautoAction < CombatAction
      include ActionOnlyAllowsSingleTarget
      
      def parse_args(args)
        parse_targets args
      end

      def check_automatic
        supports_burst = FS3Combat.weapon_stat(self.combatant.weapon, "is_automatic")
        return t('fs3combat.burst_fire_not_allowed') if !supports_burst
        return nil
      end
      
      def check_ammo
        ammo = self.combatant.ammo
        return nil if ammo.nil?
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
        t('fs3combat.fullauto_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.fullauto_action_msg_short', :target => print_target_names)
      end
      
      def resolve
        messages = []
        
        messages << t('fs3combat.fires_fullauto', :name => self.name)
        
        bullets = 6
        if (self.combatant.ammo && bullets > self.combatant.ammo)
          bullets = self.combatant.ammo
        end
        
        bullets.times.each do |b|
          messages << self.combatant.attack_target(target)
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