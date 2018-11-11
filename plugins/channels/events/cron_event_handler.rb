module AresMUSH
  module Channels   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("channels", "clear_history_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Clearing channel history."
        
        Channel.all.each do |c|
          messages = c.messages.select { |m| m['timestamp'] && (Time.now - Time.parse(m['timestamp']) < 86400 ) }
          c.update(messages: messages)
        end
        
      end
    end
  end
end
