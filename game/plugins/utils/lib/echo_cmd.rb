module AresMUSH
  module Utils
    class EchoCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :message
      
      def initialize
        self.required_args = ['message']
        self.help_topic = 'echo'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("echo")
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
