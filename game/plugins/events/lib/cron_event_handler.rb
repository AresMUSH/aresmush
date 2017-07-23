module AresMUSH
  module Events    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("events", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        #Events.refresh_events
      end
    end    
  end
end