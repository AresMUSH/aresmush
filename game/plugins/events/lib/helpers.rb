module AresMUSH
  module Events

    mattr_accessor :last_events, :last_event_time

    def self.upcoming_events
      self.last_events || []
    end
    
    def self.refresh_events(days_ahead)
      Global.dispatcher.spawn("Loading Teamup Events", nil) do
        startDate = DateTime.now
        endDate = startDate + days_ahead

        Global.logger.debug "Loading events from Teamup."
        teamup = TeamupApi.new
        self.last_events = teamup.get_events(startDate, endDate)
        self.last_event_time = Time.now
      end
    end
    
    def self.calendar_view_url
      calendar = Global.read_config("secrets", "events", "calendar")
      "https://teamup.com/#{calendar}"
    end
  end
end