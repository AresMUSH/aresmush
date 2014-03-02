module AresMUSH
  module Echo
    class EchoCmd
      include AresMUSH::Plugin
      
      # Validators
      no_switches
      
      def want_command?(client, cmd)
        cmd.root_is?("echo")
      end
      
      def handle
        client.emit cmd.args
      end
    end
  end
end
