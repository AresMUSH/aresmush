module AresMUSH
  module Login
    class CharIdledOutEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.update(login_email: nil)
      end
    end
  end
end