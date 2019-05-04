module AresMUSH
  module Page   
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("page", "unread_page_deletion_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        delete_days = Global.read_config('page', 'unread_page_deletion_days')
        
        PageMessage.select { |p| p.is_read? }.each do |msg|
          elapsed_days = (Time.now - msg.created_at) / 86400
          if (elapsed_days > delete_days)
            msg.delete
          end
        end
      end
    end
  end
end
