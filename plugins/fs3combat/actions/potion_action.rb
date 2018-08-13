module AresMUSH
  module FS3Combat
    class PotionAction < CombatAction
      
      def prepare
      end

      def print_action
        msg = t('fs3combat.potion_action_msg_long', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.potion_action_msg_short')
      end
      
      def resolve
        [t('fs3combat.potion_resolution_msg', :name => self.name)]
      end
    end
  end
end