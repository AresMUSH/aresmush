module AresMUSH
  
  class Event < Ohm::Model
    include ObjectModel

    attribute :title
    attribute :description
    attribute :date, :type => DataType::Date
    attribute :time
    
    reference :character, "AresMUSH::Character"
    
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
    
    def date_str
      formatted_date = self.datetime.strftime(Global.read_config("date_and_time", "short_date_format"))
      "#{formatted_date} @ #{self.time}"
    end
  end
end
