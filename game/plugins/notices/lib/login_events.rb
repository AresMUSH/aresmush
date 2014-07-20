module AresMUSH
  module Notices
    class LoginEvents
      include Plugin

      def initialize
        Notices.build_renderers
      end
      
      def on_char_connected_event(event)
        client = event.client
        EM.add_timer(1) do 
          client.emit Notices.notices_renderer.render(client)
        end
      end
    end
  end
end
