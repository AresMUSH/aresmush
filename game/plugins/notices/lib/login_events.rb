module AresMUSH
  module Notices
    class LoginEvents
      include CommandHandler
      
      def on_char_connected_event(event)
        client = event.client
        Global.dispatcher.queue_timer(1, "Login notices", client) do 
          template = NoticesTemplate.new(client.char, client)
          template.render
        end
      end
    end
  end
end
