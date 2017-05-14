module AresMUSH
  module Login
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Connected: #{char.name}")
        
        first_login = !char.last_ip
        Login.update_site_info(client, char)
        
        if (first_login)
          Login.check_for_suspect(char)
        end
        
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (other_char.room == char.room)
            other_client.emit_success t('login.announce_char_connected_here', :name => char.name)
          elsif (Login.wants_announce(other_char, char))
            other_client.emit_ooc t('login.announce_char_connected', :name => char.name)
          end
        end
        
        Global.dispatcher.queue_timer(1, "Login notices", client) do 
          template = NoticesTemplate.new(event.char)
          client.emit template.render
        end
      end
    end
    
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Created: #{char.name}")
        
        if (client)
          Login.update_site_info(client, char)
          Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => char.name)
        end
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
        # Ping on every cron event
        Global.client_monitor.logged_in.each do |client, char| 
          if (char.login_keepalive)
            client.ping
          end
        end
        
        config = Global.read_config("login", "activity_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        game = Game.master

        activity = game.login_activity || {}
        
        
        hour = (Time.now.hour / 4).to_s
        day_of_week = Time.now.wday.to_s
        
      
        if (!activity[day_of_week])
          activity[day_of_week] = {}
        end

        if (!activity[day_of_week][hour])
          activity[day_of_week][hour] = []
        end
        
        activity[day_of_week][hour] << Global.client_monitor.logged_in.count
        if (activity[day_of_week][hour].count > 6)
          activity[day_of_week][hour].shift
        end
        
        game.update(login_activity: activity)
      end
    end
  end
end
