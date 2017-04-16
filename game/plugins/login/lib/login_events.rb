module AresMUSH
  module Login
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Connected: #{char.name}")
        Login.update_site_info(client, char)
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (other_char.room == char.room)
            other_client.emit_success t('login.announce_char_connected_here', :name => char.name)
          elsif (Login.wants_announce(other_char, char))
            other_client.emit_ooc t('login.announce_char_connected', :name => char.name)
          end
          
          Global.dispatcher.queue_timer(1, "Login notices", client) do 
            template = NoticesTemplate.new(event.char)
            client.emit template.render
          end
        end
      end
    end
    
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Created: #{char.name}")
        Login.update_site_info(client, char)
        Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => char.name)
        Login.check_for_suspect(char)
      end
    end
    
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Disconnected: #{char.name}")
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (other_char.room == char.room)
            other_client.emit_success t('login.announce_char_disconnected_here', :name => char.name)
          elsif (Login.wants_announce(other_char, char))
            other_client.emit_ooc t('login.announce_char_disconnected', :name => char.name)
          end
        end
      end
    end
    
    class CronEventHandler
      def on_event(event)
        Global.client_monitor.logged_in.each do |client, char| 
          if (char.login_keepalive)
            client.ping
          end
        end
      end
    end
  end
end
