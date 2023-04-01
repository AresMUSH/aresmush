module AresMUSH
  module Website
    class WebCmdEventHandler
      def on_event(event)
        if (event.cmd_name == "connect")
          data = event.data
          char = Character[data["id"]]
          if (char.is_valid_api_token?(data["login_api_token"]))
            Login.connect_client_after_login(char, event.client)
          else
            event.client.emit_failure t('login.no_auto_login_time_expired')
          end
        end
      end
    end
  end
end