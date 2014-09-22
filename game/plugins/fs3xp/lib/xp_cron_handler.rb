module AresMUSH
  module FS3XP    
    class XpCronHandler
      include Plugin
      
      def on_cron_event(event)
        config = Global.config['fs3xp']['cron']
        return if !Cron.is_cron_match?(config, event.time)
        
        weekly_xp = Global.config['fs3xp']['weekly_xp']
        max_xp = Global.config['fs3xp']['max_xp_hoard']
        
        approved = Character.where(is_approved: true)
        approved.each do |a|
          if (a.xp < max_xp)
            a.xp = a.xp + weekly_xp
            a.save
          end
        end
      end
    end    
  end
end