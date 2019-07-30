module AresMUSH
  module Login
    class OnConnectCmd
      include CommandHandler
      
      attr_accessor :commands, :clear
      
      def parse_args
        self.clear = cmd.switch_is?('clear')
        self.commands = list_arg(cmd.args, ",") || []
      end
      
      def check_num_commands
        return t('login.too_many_onconnect_commands') if self.commands.count > 5
        return nil
      end

      def handle      
        if (self.clear)
          enactor.update(onconnect_commands: [])
          client.emit_success t('login.onconnect_commands_cleared')
        else
          enactor.update(onconnect_commands: self.commands)
          client.emit_success t('login.onconnect_commands_set')
        end
      end
    end
  end
end
