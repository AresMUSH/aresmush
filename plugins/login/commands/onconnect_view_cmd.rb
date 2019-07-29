module AresMUSH
  module Login
    class OnConnectViewCmd
      include CommandHandler
      def handle      
        commands = (enactor.onconnect_commands || []).join(',')        
        client.emit_success t('login.onconnect_commands', :commands => commands)
      end
    end
  end
end
