module AresMUSH
  module Login
    class CronEventHandler
      def on_event(event)
        # Ping on every cron event
        Global.client_monitor.logged_in.each do |client, char| 
          if (char.login_keepalive)
            client.ping
          end
        end
        
        if (Cron.is_cron_match?(Global.read_config("login", "activity_cron"), event.time))
          do_activity_cron
        end
        
        if (Cron.is_cron_match?(Global.read_config("login", "blacklist_cron"), event.time))
          do_blacklist_cron
        end
      end
      
      def do_activity_cron
        
        Global.logger.debug "Recording game activity."
        
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
      
      def do_blacklist_cron
        Global.logger.debug "Updating game blacklist."

        Global.dispatcher.spawn("Updating rhost blacklist", nil) do
          Login.update_blacklist
        end
      end
      
    end
  end
end
