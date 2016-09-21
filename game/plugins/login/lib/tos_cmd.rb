module AresMUSH
  module Login
    class TosCmd
      include CommandHandler
        
      def check_pending_connect
        return t('login.tos_agreement_not_pending') if !client.program[:create_cmd]
        return nil
      end
      
      def handle
        pending_cmd = client.program[:create_cmd]
        client.program[:tos_accepted] = true
        Global.dispatcher.queue_command(client, pending_cmd)
      end
    end
  end
end
