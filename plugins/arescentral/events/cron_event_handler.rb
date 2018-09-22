module AresMUSH
  module AresCentral  
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("arescentral", "directory_update_cron")
	return if !Cron.is_cron_match?(config, event.time)
        
        AresMUSH.with_error_handling(nil, "Updating game info with AresCentral.") do
          if (AresCentral.is_registered?)
            AresCentral.update_game
          elsif (AresCentral.is_public_game?)
            AresCentral.register_game
          end
        end           
      end
    end
  end
end
