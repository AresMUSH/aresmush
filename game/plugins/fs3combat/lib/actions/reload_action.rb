module AresMUSH
  module FS3Combat
    class ReloadAction < CombatAction
      
      def self.crack_helper(enactor, cmd)
        {
          :name => cmd.args ? cmd.args : enactor.name,
          :action_args => nil
        }
      end
      
      def parse_args(args)       
      end

      def print_action
        msg = t('fs3combat.reload_action_msg_long', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.reload_action_msg_short')
      end
      
      def check_uses_ammo
        return t('fs3combat.cant_reload') if !self.combatant.ammo
        return nil
      end
      
      def resolve
        self.combatant.ammo = FS3Combat.weapon_stat(self.combatant.weapon, "ammo")
        [t('fs3combat.reload_resolution_msg', :name => self.name)]
      end
    end
  end
end