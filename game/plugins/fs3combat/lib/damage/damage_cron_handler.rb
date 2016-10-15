module AresMUSH
  module FS3Combat    
    class DamageCronHandler
      include CommandHandler
      
      def on_cron_event(event)
        config = Global.read_config("fs3combat", "healing_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Character.each do |c|
          FS3Combat.heal_wounds(c)          
        end
      end
    end
  end
end