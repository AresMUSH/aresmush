module AresMUSH
  module FS3Combat
    class PassAction < CombatAction
      
      def parse_args(args)
      end

      def print_action
        msg = t('fs3combat.pass_msg', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.pass_msg_short')
      end
      
      def resolve
        t('fs3combat.passes', :name => self.name)
      end
    end
  end
end