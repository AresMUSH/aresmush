module AresMUSH
  module Login
    class Quit
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("quit")
      end
      
      def on_anon_command(client, cmd)
        client.disconnect
      end
      
      def on_command(client, cmd)
        client.disconnect
      end
    end
  end
end
