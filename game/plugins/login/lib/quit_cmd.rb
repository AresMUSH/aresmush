module AresMUSH
  module Login
    class QuitCmd
      include CommandHandler
      include CommandWithoutSwitches

      def handle
        client.emit_ooc(t("login.goodbye"))
        client.disconnect
      end
    end
  end
end
