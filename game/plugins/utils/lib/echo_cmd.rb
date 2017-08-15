module AresMUSH
  module Utils
    class EchoCmd
      include CommandHandler
      
      attr_accessor :message
      
      def parse_args
        self.message = cmd.args
      end
      
      def allow_without_login
        true
      end
      
      def required_args
        [ self.message ]
      end
      
      def handle
        client.emit self.message
      end
      
      def log_command
        # Don't log command for privacy
      end
    end
  end
end
