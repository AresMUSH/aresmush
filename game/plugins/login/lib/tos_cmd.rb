module AresMUSH
  module Login
    class TosCmd
      include Plugin

      def want_command?(client, cmd)
        cmd.root_is?("tos") && cmd.switch_is?("agree")
      end
        
      def check_pending_connect
        return t('login.tos_agreement_not_pending') if !client.program[:create_cmd]
        return nil
      end
      
      def handle
        pending_cmd = client.program[:create_cmd]
        client.program = { :tos_accepted => true }
        Global.dispatcher.on_command(client, pending_cmd)
      end
    end
  end
end
