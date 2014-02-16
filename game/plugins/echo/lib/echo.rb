module AresMUSH
  module Echo
    class Echo
      include AresMUSH::Plugin

      def want_command?(client, cmd)
        cmd.root_is?("echo") || cmd.root_is?("think")
      end
      
      def on_command(client, cmd)
        client.emit cmd.args
      end
    end
  end
end
