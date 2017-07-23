module AresMUSH
  
  class Event < Ohm::Model
    include ObjectModel

    attribute :title
    attribute :description
    attribute :date, :type => DataType::Date
    attribute :time
    
    reference :character, "AresMUSH::Character"
    
    def who
      self.character.name
    end
    
    def self.sorted_events
      Event.all.to_a.sort_by { |e| e.date }
    end
    
    def datetime
      DateTime.new(date.year, date.month, date.day, 0, 0, 0)
    end
    
    def is_upcoming?(days)
      days_away = (self.datetime.to_date - DateTime.now.to_date)
      days_away > 0 && days_away < days
    end
    
    def is_past?
      days_away = (self.datetime.to_date - DateTime.now.to_date)
      days_away < 0
    end    
    
    def color
      if ((self.date.to_time - Time.now) < 86400 )
        "%xh%xg"
      elsif ((self.date.to_time - Time.now) < 86400 * 2 )
        "%xh%xy"
      elsif ((self.date.to_time - Time.now) < 86400 * 7 )
        "%xh"
      else
        ""
      end
    end
    
    def start_time_local(enactor)
      time = self.date
      local_time = OOCTime.local_long_timestr(enactor, time.to_time)
      "#{local_time}"
    end
    
    
    def start_time_standard
      timezone = Global.read_config("events", "calendar_timezone")
      format = Global.read_config("date_and_time", "time_format")
      formatted_time = self.date.strftime(format).strip
      "#{formatted_time} #{timezone}"
    end
    
    def start_datetime_standard
      time = self.date
      formatted_time = time.to_time.strftime "%a %b %d, %Y %l:%M%P"
      timezone = Global.read_config("events", "calendar_timezone")
      "#{formatted_time}#{timezone}"
    end
    
    
    def date_str
      formatted_date = self.datetime.strftime(Global.read_config("date_and_time", "short_date_format"))
      "#{formatted_date} @ #{self.time}"
    end
  end
end
