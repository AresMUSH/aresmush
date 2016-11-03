module AresMUSH
  module FS3Combat
    class ReloadAction < CombatAction
      
      def prepare
        return t('fs3combat.cant_reload') if !self.combatant.max_ammo
        return nil
      end

      def print_action
        msg = t('fs3combat.reload_action_msg_long', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.reload_action_msg_short')
      end
            
      def resolve
        self.combatant.update(ammo: self.combatant.max_ammo)
        [t('fs3combat.reload_resolution_msg', :name => self.name)]
      end
    end
  end
end