module AresMUSH
  module Login
    class Quit
      include AresMUSH::Plugin

      # Validators
      dont_allow_switches_or_args

      def want_command?(client, cmd)
        cmd.root_is?("quit")
      end
            
      def handle
        client.emit_ooc(t("login.goodbye"))
        client.disconnect
      end
    end
  end
end
