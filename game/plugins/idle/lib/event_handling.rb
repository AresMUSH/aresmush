module AresMUSH
  module Idle
    class CharConnectedEventHandler
      def on_event(event)
        char = event.char
        if (char.idle_warned)
          char.update(idle_warned: false)
        end
      end
    end
    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("idle", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        category = Global.read_config('idle', 'reminder_category')
        reminder = Global.read_config("idle", "monthly_reminder")
        title = Global.read_config("idle", "monthly_reminder_title")
        Jobs::Api.create_job(category, 
               title, 
               reminder, 
               Game.master.system_character)          
      end
    end
  end
end