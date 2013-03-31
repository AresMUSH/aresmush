module AresMUSH
  module Login
    class Quit
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("quit")
      end
      
      def want_anon_command?(cmd)
        cmd.root_is?("quit")
      end
            
      def on_command(client, cmd)
        client.emit_ooc(t("login.goodbye"))
        client.disconnect
      end
    end
  end
end
