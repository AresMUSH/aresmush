module AresMUSH
  module Page   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("page", "page_deletion_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        delete_days = Global.read_config('page', 'page_deletion_days')
        
        Global.logger.debug "Clearing old pages."
        PageMessage.all.each do |msg|
          elapsed_days = (Time.now - msg.created_at) / 86400
          if (elapsed_days > delete_days)
            thread = msg.page_thread
            msg.delete
            if (thread.page_messages.count == 0)
              thread.delete
            end
          end
        end
      end
    end
  end
end
