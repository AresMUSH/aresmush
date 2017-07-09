module AresMUSH
  module Events

    mattr_accessor :last_events, :last_event_time
    
    def self.refresh_events(days_ahead = 14)
      Global.dispatcher.spawn("Loading Teamup Events", nil) do
        startDate = DateTime.now
        endDate = startDate + days_ahead

        Global.logger.debug "Loading events from Teamup."
        teamup = TeamupApi.new
        
        old_events = {}
        if (self.last_events)
          self.last_events.each do |e|
            old_events[e.title] = e.start_datetime_standard
          end
        end
        
        self.last_events = teamup.get_events(startDate, endDate)
        self.last_event_time = Time.now
        
        new_events = {}
        self.last_events.each do |e|
          new_events[e.title] = e.start_datetime_standard
        end
                
        cancelled_events = old_events.keys - new_events.keys
        added_events = new_events.keys - old_events.keys
        updated_events = (new_events.keys & old_events.keys).select { |k| old_events[k] != new_events[k] }
        

        list = []
        added_events.each do |event| 
          list << "#{t('events.event_added')} #{event} @ #{new_events[event]}"
        end
        
        updated_events.each do |event| 
          list << "#{t('events.event_updated')} #{event} @ #{new_events[event]}"
        end
        
        cancelled_events.each do |event| 
          list << "#{t('events.event_cancelled')} #{event} @ #{old_events[event]}"
        end
        
        if (list.any?)
          Global.client_monitor.emit_all_ooc t('events.new_events', :events => list.join("%r%% - "))
        end
      end
    end
    
    def self.event_titles
      return [] if !self.last_events
      self.last_events.map { |e| "#{e.title} #{e.start_datetime_standard}"}
    end
  end
end