module AresMUSH
  module Login
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        Global.logger.info("Character Connected: #{client}")
        Login.update_site_info(client, event.char)
        Global.client_monitor.logged_in_clients.each do |c|
          if (c.room == client.room)
            c.emit_success t('login.announce_char_connected_here', :name => client.name)
          elsif (Login.wants_announce(c.char, event.char))
            c.emit_ooc t('login.announce_char_connected', :name => client.name)
          end
        end
      end
    end
    
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        Global.logger.info("Character Created: #{client}")
        Login.update_site_info(client, event.char)
        Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => client.name)
        Login.check_for_suspect(event.char)
      end
    end
    
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        Global.logger.info("Character Disconnected: #{client}")
        Global.client_monitor.logged_in_clients.each do |c|
          if (c.room == client.room)
            c.emit_success t('login.announce_char_disconnected_here', :name => client.name)
          elsif (Login.wants_announce(c.char, event.char))
            c.emit_ooc t('login.announce_char_disconnected', :name => client.name)
          end
        end
      end
    end
  end
end
