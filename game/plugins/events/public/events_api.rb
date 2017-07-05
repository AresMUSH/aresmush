module AresMUSH
  module Events
    def self.upcoming_events
      self.last_events || []
    end
        
    def self.calendar_view_url
      calendar = Global.read_config("secrets", "events", "calendar")
      "https://teamup.com/#{calendar}"
    end
  end
end