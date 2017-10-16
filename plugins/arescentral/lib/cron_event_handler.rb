module AresMUSH
  module AresCentral  
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("arescentral", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        AresMUSH.with_error_handling(nil, "Updating game info with AresCentral.") do
        
          if (Game.master.api_key)
            AresCentral.update_game
          else
            AresCentral.register_game
          end
        end           
      end
    end
  end
end