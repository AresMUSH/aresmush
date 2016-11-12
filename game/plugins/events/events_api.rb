module AresMUSH
  module Events
    module Api
      def self.upcoming_events
        Events.upcoming_events(7)
      end
    end
  end
end