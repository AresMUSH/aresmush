module AresMUSH
  module FS3Combat
    class PotionAction < CombatAction

      def prepare
      end

      def print_action
        msg = t('custom.potion_action_msg_long', :name => self.name)
      end

      def print_action_short
        t('custom.potion_action_msg_short')
      end

      def resolve
        [t('custom.potion_resolution_msg', :name => self.name)]
      end
    end
  end
end
