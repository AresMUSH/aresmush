module AresMUSH
  module AresCentral
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("arescentral", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        AresMUSH.with_error_handling(nil, "Syncing handle with AresCentral.") do
        
          if (Game.master.api_key)
            Api.update_game
          else
            Api.register_game
          end
        end           
      end
    end
  end
end