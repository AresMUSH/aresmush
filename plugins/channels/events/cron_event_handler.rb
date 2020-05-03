module AresMUSH
  module Channels   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("channels", "clear_history_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Clearing channel history."
        
        timeout_secs = (Global.read_config("channels", "recall_timeout_days") || 1) * 86400
        ChannelMessage.all.select { |c| Time.now - c.created_at > timeout_secs }.each { |c| c.delete }
      end
    end
  end
end
