module AresMUSH
  module Utils
    class EchoCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :message
      
      def initialize(client, cmd, enactor)
        self.required_args = ['message']
        self.help_topic = 'echo'
        super
      end
      
      def crack!
        self.message = cmd.args
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
