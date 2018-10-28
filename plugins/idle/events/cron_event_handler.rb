module AresMUSH
  module Idle
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("idle", "monthly_reminder_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Monthly idle reminder."
        
        category = Global.read_config('idle', 'reminder_category')
        reminder = Global.read_config("idle", "monthly_reminder")
        title = Global.read_config("idle", "monthly_reminder_title")
        Jobs.create_job(category, 
               title, 
               reminder, 
               Game.master.system_character)          
      end
    end
  end
end