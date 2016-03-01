module AresMUSH
  module Login
    class QuitCmd
      include CommandHandler
      include CommandWithoutSwitches

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
