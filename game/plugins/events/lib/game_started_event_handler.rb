module AresMUSH
  module Events    
    class GameStartedEventHandler
      def on_event(event)
        Events.refresh_events
      end
    end    
  end
end