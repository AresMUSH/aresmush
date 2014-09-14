module AresMUSH
  module Login
    class LoginEvents
      include Plugin
      
      def on_char_connected_event(event)
        client = event.client
        Global.logger.info("Character Connected: #{client}")
        Global.client_monitor.logged_in_clients.each do |c|
          if (c.room == client.room)
            c.emit_success t('login.announce_char_connected_here', :name => client.name)
          elsif (Login.wants_announce(c.char, client.char))
            c.emit_ooc t('login.announce_char_connected', :name => client.name)
          end
        end
      end
      
      def on_char_created_event(event)
        client = event.client
        Global.logger.info("Character Created: #{client}")
        Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => client.name)
      end

      def on_char_disconnected_event(event)
        client = event.client
        Global.logger.info("Character Disconnected: #{client}")
        Global.client_monitor.logged_in_clients.each do |c|
          if (c.room == client.room)
            c.emit_success t('login.announce_char_disconnected_here', :name => client.name)
          elsif (Login.wants_announce(c.char, client.char))
            c.emit_ooc t('login.announce_char_disconnected', :name => client.name)
          end
        end
      end
    end
  end
end
