module AresMUSH
  module FS3Combat    
    class DamageCronHandler      
      def on_event(event)
        config = Global.read_config("fs3combat", "healing_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Clearing damage."
        
        Character.all.each do |c|
          FS3Combat.heal_wounds(c)   
        end
        
        Healing.all.each do |h|
          if (FS3Combat.total_damage_mod(h.patient) == 0)
            h.delete
          end
        end
      end
    end
  end
end