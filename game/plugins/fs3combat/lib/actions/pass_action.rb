module AresMUSH
  module FS3Combat
    class PassAction < CombatAction
      
      def self.crack_helper(client, cmd)
        if (cmd.args)
          name = InputFormatter.titleize_input(cmd.args)
        else
          name = client.name
        end
        {
          :name => name,
          :action_args => ""
        }
      end
      
      def parse_args(args)
      end

      def print_action
        msg = t('fs3combat.pass_action_msg_long', :name => self.name)
      end
      
      def print_action_short
        t('fs3combat.pass_action_msg_short')
      end
      
      def resolve
        [t('fs3combat.pass_resolution_msg', :name => self.name)]
      end
    end
  end
end