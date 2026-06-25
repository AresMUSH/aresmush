module AresMUSH
  module Login
    class CronEventHandler
      def on_event(event)
        # Ping on every cron event
        Global.client_monitor.client_to_char_map.each do |client, char| 
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
        
        if (Cron.is_cron_match?(Global.read_config("login", "notice_cleanup_cron"), event.time))
          do_notice_cleanup_cron
        end
        
        if (Cron.is_cron_match?(Global.read_config("login", "cleanup_guests_cron"), event.time))
          do_cleanup_guest_cron
        end
      end
      
      def do_activity_cron
        
        Global.logger.debug "Recording game activity."
        
        game = Game.master

        activity = game.login_activity || {}
        
        estnow = Time.now.localtime("-05:00")
        hour = (estnow.hour / 4).to_s
        day_of_week = estnow.wday.to_s
        
      
        if (!activity[day_of_week])
          activity[day_of_week] = {}
        end

        if (!activity[day_of_week][hour])
          activity[day_of_week][hour] = []
        end
        
        activity[day_of_week][hour] << Who.all_online.count
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
      
      def do_notice_cleanup_cron
        Global.logger.debug "Cleaning up old notices"
        timeout_days = Global.read_config('login', 'notice_timeout_days') || 60
        old_notices = LoginNotice.all.select { |n| (Time.now - n.created_at) > 86400 * timeout_days } 
        Global.logger.debug "Deleting #{old_notices.count} old notices."
        old_notices.each { |n| n.delete }
      end
      
      def do_cleanup_guest_cron
        Global.logger.debug "Cleaning up old guests"
        guest_names = Global.read_config("names", "guest") || []
        idle_days = Global.read_config("login", "idle_guest_days") || 7
        idle = []
        guest_names.each do |name|
           char = Character.named(name)
           next if !char
           next if Login.is_online_or_on_web?(char)
           if (Time.now - char.last_on > 86400 * idle_days)
             idle << char
           end
        end
        idle.each do |char|
          Idle.idle_cleanup(char, "Destroy")
          char.delete
        end
      end
      
    end
  end
end
