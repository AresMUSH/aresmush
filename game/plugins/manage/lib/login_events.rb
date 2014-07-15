module AresMUSH
  module Manage
    class LoginEvents
      include Plugin

      def on_char_connected_event(event)
        client = event.client
        client.char.last_ip = client.ip_addr
        client.char.last_hostname = client.hostname.downcase
        client.char.last_on = DateTime.now
        client.char.save
      end
      
      def on_char_disconnected_event(event)
        client = event.client
        client.char.last_on = DateTime.now
        client.char.save
      end
    end
  end
end
