module AresMUSH
  module Events

    mattr_accessor :last_events, :last_event_time
    
    def self.refresh_events(days_ahead)
      Global.dispatcher.spawn("Loading Teamup Events", nil) do
        startDate = DateTime.now
        endDate = startDate + days_ahead

        Global.logger.debug "Loading events from Teamup."
        teamup = TeamupApi.new
        
        old_event_titles = event_titles
        
        self.last_events = teamup.get_events(startDate, endDate)
        self.last_event_time = Time.now
        
        if (old_event_titles != event_titles)
          new_events = event_titles - old_event_titles 
          cancelled_events = old_event_titles - event_titles
          
          if (new_events.count > 0)
            Global.client_monitor.emit_all_ooc t('events.new_events', :events => new_events.join("%r- "))
          end
          if (cancelled_events.count > 0)
            Global.client_monitor.emit_all_ooc t('events.cancelled_events', :events => cancelled_events.join("%r- "))
          end
        end
      end
    end
    
    def self.event_titles
      return [] if !self.last_events
      self.last_events.map { |e| "#{e.title} #{e.start_datetime_standard}"}
    end
  end
end