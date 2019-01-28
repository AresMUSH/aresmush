module AresMUSH
  module Login
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        Global.logger.info("Character Disconnected: #{char.name}")
        char.room.emit_success t('login.announce_char_disconnected_here', :name => char.name)
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (Login.wants_announce(other_char, char) && other_char.room != char.room)
            other_client.emit_ooc t('login.announce_char_disconnected', :name => char.name)
          end
        end
      end
    end
  end
end
