module AresMUSH
  module Bbs
    class LoginEvents
      include Plugin

      # TODO - Temporary until MOTD command is done.
      def on_char_connected_event(event)
        client = event.client
        client.emit Bbs.board_list_renderer.render(client)
      end
    end
  end
end
