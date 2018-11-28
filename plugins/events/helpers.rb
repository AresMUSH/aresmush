module AresMUSH
  module Events
    def self.can_manage_events?(actor)
      actor.has_permission?("manage_events")
    end
    def self.ical_path
      File.join(AresMUSH.game_path, 'calendar.ics')
    end
        
    def self.parse_date_time_desc(str)
      begin
        split = str.split('/')
        date = split[0..2].join('/')
        desc = split[3..-1].join("/")
        date_time = OOCTime.parse_datetime(date.strip.downcase)
        
        if (date_time < DateTime.now)
          return nil, nil, t('events.no_past_events')
        end
        
        return date_time, desc, nil
      rescue Exception => e
        error = t('events.invalid_event_date', 
        :format_str => Global.read_config("datetime", "date_and_time_entry_format_help"))        
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
    
    def self.can_manage_event(enactor, event)
      return Events.can_manage_events?(enactor) || enactor == event.character
    end
    
    def self.signup_for_event(event, char, comment)
      signup = event.signups.select { |s| s.character == char }.first
      
      if (signup)
        signup.update(comment: comment)
      else
        EventSignup.create(event: event, character: char, comment: comment)
      end
    end
    
    def self.create_event(enactor, title, datetime, desc)
      event = Event.create(title: title, 
      starts: datetime, 
      description: desc,
      character: enactor)
        
      message = t('events.event_created', :title => event.title,
        :starts => event.start_datetime_standard, :name => enactor.name)
        
      Global.notifier.notify_ooc(:event_created, message) do |char|
        true
      end

      Events.events_updated
      Events.handle_event_achievement(enactor)
      return event
    end
   
    def self.delete_event(event, enactor)
      event.delete
      message = t('events.event_deleted', :title => event.title,
        :starts => event.start_time_standard, :name => enactor.name)
      Global.notifier.notify_ooc(:event_deleted, message) do |char|
        true
      end
      Events.events_updated
    end
   
    def self.update_event(event, enactor, title, datetime, desc)
      event.update(title: title)
      event.update(starts: datetime)
      event.update(description: desc)
     
      message = t('events.event_updated', :title => event.title,
        :starts => event.start_datetime_standard, :name => enactor.name)
      
      Global.notifier.notify_ooc(:event_updated, message) do |char|
        true
      end
      Events.events_updated
    end
   
    def self.format_timestamp(time)
      time.utc.iso8601.gsub(":", "").gsub("-", "")
    end
    
    def self.events_updated
      File.open(Events.ical_path, 'w') do |f|
        f.puts "BEGIN:VCALENDAR"
        f.puts "VERSION:2.0"
        f.puts "PRODID:-//hacksw/handcal//NONSGML v1.0//EN"
                  
        Event.all.each do |event|
          f.puts "BEGIN:VEVENT"
          f.puts "UID:#{event.ical_uid}"
          f.puts "DTSTART:#{Events.format_timestamp(event.starts)}"
          f.puts "DTSTAMP:#{Events.format_timestamp(event.created_at)}"
          f.puts "SUMMARY:#{event.title}"
          f.puts "DESCRIPTION:#{event.description.gsub("%r", "\r\n  ")}"
          f.puts "END:VEVENT"
        end
        
        f.puts "END:VCALENDAR"
      end
    end
    
    def self.handle_event_achievement(char)
        Achievements.award_achievement(char, "event_created", 'community', "Scheduled an event.")
    end
  end
end