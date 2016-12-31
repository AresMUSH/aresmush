module AresMUSH
  module Utils
    class EchoCmd
      include CommandHandler
      
      attr_accessor :message
      
      def crack!
        self.message = cmd.args
      end
      
      def allow_without_login
        true
      end
      
      def required_args
        {
          args: [ self.message ],
          help: 'echo'
        }
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
