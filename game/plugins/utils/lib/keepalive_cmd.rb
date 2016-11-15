module AresMUSH
  module Utils
    class KeepaliveCmd
      include CommandHandler

      def handle
        # A command that does absolutely nothing!
      end

      def log_command
        # Don't log useless command
      end
    end
  end
end