module AresMUSH
  
  class Event < Ohm::Model
    include ObjectModel

    attribute :title
    attribute :description
    attribute :starts, :type => DataType::Time
    attribute :reminded, :type => DataType::Boolean
    attribute :ical_uid
    
    reference :character, "AresMUSH::Character"
    
    before_save :set_uid
    
    def set_uid
      if (!self.ical_uid)
        host = Global.read_config('server', 'hostname' )
        game = Global.read_config('game', 'name' )
        self.ical_uid = "#{SecureRandom.uuid}@#{game}-#{host}"
      end
    end
    
    def organizer_name
      self.character ? self.character.name : ""
    end
    
    def who
      organizer_name
    end
    
    def self.sorted_events
      Event.all.to_a.sort_by { |e| e.starts }
    end
    
    def is_upcoming?(days)
      days_away = time_until_event / 86400.0
      days_away > 0 && days_away < days
    end
    
    def is_past?
      time_until_event < 0
    end    
    
    def time_until_event
      (self.starts.to_time - Time.now)
    end
    
    def color
      time = time_until_event
      if (time < 0)
        "%xh%xx"
      elsif (time < 86400 )
        "%xh%xg"
      elsif (time < 86400 * 2 )
        "%xh%xy"
      elsif (time < 86400 * 7 )
        "%xh"
      else
        ""
      end
    end
    
    def start_time_local(enactor)
      local_time = OOCTime.local_long_timestr(enactor, starts)
      "#{local_time}"
    end
    
    def start_time_standard
      timezone = Global.read_config("events", "calendar_timezone")
      format = Global.read_config("date_and_time", "time_format")
      formatted_time = self.starts.strftime(format).strip
      "#{formatted_time} #{timezone}"
    end
    
    def start_datetime_standard
      formatted_time = starts.strftime "%a %b %d, %Y %l:%M%P"
      timezone = Global.read_config("events", "calendar_timezone")
      "#{formatted_time}#{timezone}"
    end
    
    
    def date_str
      self.starts.strftime(Global.read_config("date_and_time", "short_date_format"))
    end
  end
end
