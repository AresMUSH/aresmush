module AresMUSH
  module Login
    class QuitCmd
      include CommandHandler

      def help
        "`quit` - Disconnects from the game."
      end
      
      def allow_without_login
        true
      end
      
      def handle
        client.emit_ooc(t("login.goodbye"))
        client.disconnect
      end
    end
  end
end
