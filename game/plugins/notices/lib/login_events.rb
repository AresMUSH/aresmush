module AresMUSH
  module Notices
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        Global.dispatcher.queue_timer(1, "Login notices", client) do 
          template = NoticesTemplate.new(client.char, client)
          template.render
        end
      end
    end
  end
end
