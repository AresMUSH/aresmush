module AresMUSH
  module Api
    class ApiEventHandler
      include CommandHandler
          
      def on_cron_event(event)
        config = Global.read_config("api", "cron")
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