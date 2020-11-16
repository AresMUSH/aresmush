module AresMUSH
  
  class Event < Ohm::Model
    include ObjectModel

    attribute :title
    attribute :description
    attribute :starts, :type => DataType::Time
    attribute :reminded, :type => DataType::Boolean
    attribute :ical_uid
    attribute :content_warning
    attribute :tags, :type => DataType::Array, :default => []
    
    reference :character, "AresMUSH::Character"
    collection :signups, "AresMUSH::EventSignup"
    
    before_save :set_uid
    before_delete :delete_signups
    
    def set_uid
      # Need a unique identifier for ical
      if (!self.ical_uid)
        host = Global.read_config('server', 'hostname')
        game = Global.read_config('game', 'name' )
        self.ical_uid = "#{SecureRandom.uuid}@#{game}-#{host}"
      end
    end
    
    def delete_signups
      self.signups.each { |s| s.delete }
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
    
    def is_signed_up?(char)
      return nil if !char
      return true if self.character == char
      return self.signups.any? { |e| e.character == char }
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
    
    def ordered_signups
      self.signups.to_a.sort_by { |s| s.created_at }
    end
    
    def start_datetime_local(enactor)
      local_time = OOCTime.local_long_timestr(enactor, starts)
      "#{local_time}"
    end
    
    def start_time_standard
      OOCTime.server_timestr(self.starts)
    end
    
    def start_datetime_standard
      time_format = Global.read_config("datetime", "time_format")
      format = "%a %b %d, %Y #{time_format}"
      formatted_time = l(self.starts, format: format)
      timezone = Global.read_config("datetime", "server_timezone")
      "#{formatted_time}#{timezone}"
    end
    
    
    def date_str
      format = Global.read_config("datetime", "short_date_format")
      l(self.starts, format: format)
    end
  end
end
