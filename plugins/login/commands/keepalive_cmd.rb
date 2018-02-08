module AresMUSH
  module Login
    class KeepaliveCmd
      include CommandHandler
      
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