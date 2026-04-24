module AresMUSH
  module Login
    class RoleChangedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        Login.expire_web_login(char)
      end
    end
  end
end
