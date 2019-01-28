module AresMUSH
  module Channels   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("channels", "clear_history_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Clearing channel history."
        
        timeout_secs = (Global.read_config("channels", "recall_message_timeout_days") || 1) * 86400
        Channel.all.each do |c|
          messages = c.messages.select { |m| m['timestamp'] && (Time.now - Time.parse(m['timestamp']) < timeout_secs ) }
          c.update(messages: messages)
        end
        
      end
    end
  end
end
