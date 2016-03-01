module AresMUSH
  module Manage
    class LoginEvents
      include CommandHandler

      def on_char_connected_event(event)
        client = event.client
        client.char.last_on = Time.now
        client.char.save
      end
      
      def on_char_disconnected_event(event)
        client = event.client
        client.char.last_on = Time.now
        client.char.save
      end
    end
  end
end
