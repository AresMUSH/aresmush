module AresMUSH
  module Events    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("events", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Event.all.each do |e|
          if (!e.reminded && e.time_until_event < (60 * 20))
            Global.client_monitor.emit_all_ooc t('events.event_starting_soon', :title => e.title,
               :starts => e.start_time_standard)
             e.update(reminded: true)
          end
          
          if (e.time_until_event < 0)
            e.delete
          end
        end
      end
    end    
  end
end