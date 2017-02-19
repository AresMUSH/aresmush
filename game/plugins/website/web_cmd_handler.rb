module AresMUSH
  module Website
    class WebCmdEventHandler
      def on_event(event)
        if (event.cmd_name == "connect")
          data = event.data
          char = Character[data["id"]]
          if (char && (data["login_api_token"] == char.login_api_token))
            Login::Api.login_char(char, event.client)
          end
        end
      end
    end
  end
end