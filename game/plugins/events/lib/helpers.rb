module AresMUSH
  module Events
    def self.can_manage_events?(actor)
      actor.has_permission?("manage_events")
    end
    
    def self.parse_date_time_desc(str)
      begin
        split = str.split('/')
        date = split[0..2].join('/')
        desc = split[3..-1].join("/")
        date_time = OOCTime.parse_datetime(date.strip.downcase)
        
        return date_time, desc, nil
      rescue Exception => e
        error = t('events.invalid_event_date', 
           :format_str => Global.read_config("date_and_time", "date_and_time_entry_format_help"))        
        return nil, nil, error
      end
    end
    
    
    def self.with_an_event(num, client, enactor, &block)
      events = Event.sorted_events
      if (num < 0 || num > events.count)
        client.emit_failure t('events.invalid_event')
        return
      end
      
      yield events.to_a[num - 1]
    end    
  end
end