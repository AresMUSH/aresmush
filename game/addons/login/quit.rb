module AresMUSH
  module Login
    class Quit
      include AresMUSH::Addon

      def want_command?(cmd)
        cmd.root_is?("quit")
      end
      
      def on_anon_command(cmd)
        cmd.client.disconnect
      end
      
      def on_command(cmd)
        cmd.client.disconnect
      end
    end
  end
end
