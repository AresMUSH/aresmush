module AresMUSH
  module Website
    class WebCmdEventHandler
      def on_event(event)
        event.client.emit "Woot! #{event.data}"
        if (event.cmd_name == "connect")
          data = event.data
          char = Character[data["id"]]
          Login::Api.login_char(char, event.client)
        end
      end
    end
  end
end