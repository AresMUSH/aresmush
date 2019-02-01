module AresMUSH
  module Forum   
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]

        char.update(forum_muted: false)
      end
    end
  end
end
