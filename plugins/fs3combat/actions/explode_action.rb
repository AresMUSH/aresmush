module AresMUSH
  module FS3Combat
    class ExplodeAction < CombatAction      
      def prepare
        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.not_explosive_weapon') if weapon_type != "Explosive"
        
        error = self.parse_targets(self.action_args)
        return error if error
      
        return t('fs3combat.too_many_targets') if (self.targets.count > 3)
      
        return t('fs3combat.out_of_ammo') if !FS3Combat.check_ammo(self.combatant, 1)
        
        return nil
      end
      
      def print_action
        t('fs3combat.explode_action_msg_long', :name => self.name, :targets => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.explode_action_msg_short', :targets => print_target_names)
      end
      
      def resolve
        messages = []
        
        messages << t('fs3combat.explode_resolution_message', :name => self.name, :weapon => self.combatant.weapon)
        
        self.targets.each do |target, num|
          messages.concat FS3Combat.resolve_explosion(combatant, target)
        end

        ammo_message = FS3Combat.update_ammo(@combatant, 1)
        if (ammo_message)
          messages << ammo_message
        end
        
        messages
      end
    end
  end
end