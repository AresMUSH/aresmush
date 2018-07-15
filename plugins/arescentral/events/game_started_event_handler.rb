module AresMUSH
  module AresCentral
    class GameStartedEventHandler
      def on_event(event)
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