module AresMUSH
  module Utils
    class BeepCmd
      include CommandHandler
      
      attr_accessor :message
      
      def handle
        client.beep
      end
      
      def log_command
        # Silly command to log.
      end
    end
  end
end
