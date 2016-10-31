module AresMUSH
  module FS3Combat
    class ReloadAction < CombatAction
      
      def prepare
        return t('fs3combat.cant_reload') if !self.combatant.ammo
        return nil
      end

      def print_action
        msg = t('fs3combat.reload_action_msg_long', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.reload_action_msg_short')
      end
            
      def resolve
        max_ammo = FS3Combat.weapon_stat(self.combatant.weapon, "ammo")
        self.combatant.update(ammo: max_ammo)
        [t('fs3combat.reload_resolution_msg', :name => self.name)]
      end
    end
  end
end