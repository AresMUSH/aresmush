module AresMUSH
  module Events
    def self.upcoming_events(days_ahead = 14)
      Event.sorted_events.select { |e| e.is_upcoming?(days_ahead) }
    end
  end
end