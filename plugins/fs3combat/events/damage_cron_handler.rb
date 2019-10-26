module AresMUSH
  module FS3Combat    
    class DamageCronHandler      
      def on_event(event)
        config = Global.read_config("fs3combat", "healing_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Time for healing."
        
        Character.all.each do |c|
          FS3Combat.heal_wounds(c)  
# Fatigue
          fatigue = c.fatigue
          if (fatigue == nil)
            fatigue = 0
          else
            fatigue = c.fatigue
          end
          new_fatigue = fatigue.to_i - 1
          if (fatigue.to_i > 0)
            c.update(fatigue: new_fatigue)
          end
# End Fatigue
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
