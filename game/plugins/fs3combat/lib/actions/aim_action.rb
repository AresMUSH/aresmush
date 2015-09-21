module AresMUSH
  module FS3Combat
    class AimAction < CombatAction
      include ActionOnlyAllowsSingleTarget
      
      def parse_args(args)
        parse_targets args
      end

      def print_action
        msg = t('fs3combat.aim_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.aim_action_msg_short', :name => self.name, :target => print_target_names)
      end
      
      def resolve
        self.combatant.is_aiming = true
        self.combatant.aim_target = print_target_names
        [t('fs3combat.aim_resolution_msg', :name => self.name, :target => print_target_names)]
      end
    end
  end
end