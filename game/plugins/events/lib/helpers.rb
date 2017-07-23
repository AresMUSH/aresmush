module AresMUSH
  module Events
    def self.can_manage_events?(actor)
      actor.has_permission?("manage_events")
    end
    
    def self.parse_date_time_desc(str)
      begin
        split = str.split('/')
        date_format = Global.read_config("date_and_time", "short_date_format")
        date = Date.strptime(split[0..2].join('/'), date_format)
        time = split[3]
        desc = split[4..-1].join("/")
        
        return date, time, desc, nil
      rescue Exception => e
        puts e
        error = t('events.invalid_event_date', 
                   :format_str => Global.read_config("date_and_time", "date_entry_format_help"))
        
        return nil, nil, nil, error
      end
    end
    
    
    def self.with_an_event(num, client, enactor, &block)
      events = Events.upcoming_events
      if (num < 0 || num > events.count)
        client.emit_failure t('events.invalid_event')
        return
      end
      
      yield events.to_a[num - 1]
    end
    
  end
end