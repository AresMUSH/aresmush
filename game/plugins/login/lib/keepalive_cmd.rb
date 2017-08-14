module AresMUSH
  module Login
    class KeepaliveCmd
      include CommandHandler

      def help
        "`keepalive` or `@@` - Sends an empty command to the game."
      end
      
      def allow_without_login
        true
      end
      
      def handle
        # A command that does absolutely nothing!     
      end

      def log_command
        # Don't log useless command
      end
    end
  end
end