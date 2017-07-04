module AresMUSH
  module AresCentral
    class GameStartedEventHandler
      def on_event(event)
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