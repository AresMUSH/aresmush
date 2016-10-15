module AresMUSH
  module FS3Skills    
    class XpCronHandler
      include CommandHandler
      
      def on_cron_event(event)
        config = Global.read_config("fs3skills", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        periodic_xp = Global.read_config("fs3skills", "periodic_xp")
        max_xp = Global.read_config("fs3skills", "max_xp_hoard")
        
        approved = Idle::Api.active_chars.select { |c| c.is_approved? }
        approved.each do |a|
          FS3Skills.modify_xp(a, periodic_xp)
        end
      end
    end    
  end
end