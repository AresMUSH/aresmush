module AresMUSH
  module ExpandedMounts 
    class ExpandedMountsDamageCronHandler      
      def on_event(event)
        config = Global.read_config("expandedmounts", "healing_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Time for healing mounts."
        
        Mount.all.each do |m|
          ExpandedMounts.heal_wounds(m)   
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