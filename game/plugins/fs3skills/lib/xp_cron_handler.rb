module AresMUSH
  module FS3Skills    
    class XpCronHandler
      include CommandHandler
      
      def on_cron_event(event)
        config = Global.read_config("fs3skills", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        periodic_xp = Global.read_config("fs3skills", "periodic_xp")
        max_xp = Global.read_config("fs3skills", "max_xp_hoard")
        
        approved = Character.find(is_approved: true)
        approved.each do |a|
          if (a.xp < max_xp)
            a.xp = a.xp + periodic_xp
            a.save
          end
        end
      end
    end    
  end
end