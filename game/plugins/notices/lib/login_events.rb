module AresMUSH
  module Notices
    class LoginEvents
      include Plugin
      
      def on_char_connected_event(event)
        client = event.client
        Global.dispatcher.queue_timer(1, "Login notices") do 
          template = NoticesTemplate.new(client.char)
          client.emit template.display
        end
      end
    end
  end
end
