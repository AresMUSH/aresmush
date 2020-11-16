module AresMUSH
  module Events    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("events", "event_alert_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Upcoming event notifications."
        
        Event.all.each do |e|
          time_until_event = e.time_until_event
          if (!e.reminded &&  time_until_event < (60 * 20) && time_until_event > 0)
            
            message = t('events.event_starting_soon', :title => e.title,
               :starts => e.start_time_standard)
            Channels.announce_notification(message)
            
            Global.notifier.notify_ooc(:event_starting, message) do |char|
              char && e.is_signed_up?(char)
            end
            
            e.update(reminded: true)
          end
          
          timeout_secs = 60 * 60 * 1 # 1 hour
          if (e.time_until_event < (0 - timeout_secs))
            e.delete
          end
        end
      end
    end    
  end
end