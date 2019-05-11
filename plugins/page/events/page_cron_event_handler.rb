module AresMUSH
  module Page   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("page", "page_deletion_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        delete_days = Global.read_config('page', 'page_deletion_days')
        
        PageMessage.all.each do |msg|
          elapsed_days = (Time.now - msg.created_at) / 86400
          if (elapsed_days > delete_days)
            msg.delete
          end
        end
      end
    end
  end
end
