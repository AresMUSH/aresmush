module AresMUSH
  module Login
    class RoleChangedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.update(login_api_token: nil)
      end
    end
  end
end
