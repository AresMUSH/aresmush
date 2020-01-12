module AresMUSH
  module Login
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        char = Character[event.char_id]
        char.update(login_email: nil)
      end
    end
  end
end