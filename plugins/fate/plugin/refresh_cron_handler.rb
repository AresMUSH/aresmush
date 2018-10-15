module AresMUSH
  module Fate    
    class RefreshCronHandler
      def on_event(event)
        config = Global.read_config("fate", "refresh_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Fate.refresh_fate
      end
    end    
  end
end