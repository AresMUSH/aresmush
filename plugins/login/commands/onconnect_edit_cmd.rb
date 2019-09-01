module AresMUSH
  module Login
    class OnConnectEditCmd
      include CommandHandler
      
      def handle      
        commands = (enactor.onconnect_commands || []).join(',')
        Utils.grab client, enactor, "onconnect #{commands}"
      end
    end
  end
end
