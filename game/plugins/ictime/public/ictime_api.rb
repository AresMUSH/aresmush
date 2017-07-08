module AresMUSH
  module ICTime
    def self.ictime
      t = DateTime.now
      year = t.year + Global.read_config("ictime", "year_offset")
      
      begin
        DateTime.new(year, t.month, t.day, t.hour, t.minute, t.sec) +  Global.read_config("ictime", "day_offset")
      rescue Exception => ex
        Global.logger.error "Error converting RL time to IC time.  Using RL time instead.  Error=#{ex}"
        return t
      end
        
    end
    
    # Used in certain places where you don't want to display the full date and time
    # and just want a shorter version - typically just month/day/year
    def self.ic_datestr(time)
      ICTime.ic_short_timestr(time)
    end
        
    def self.ic_short_timestr(time)
      time.strftime Global.read_config("date_and_time", "short_date_format")
    end
  
    def self.ic_long_timestr(time)
      time.strftime Global.read_config("date_and_time", "long_date_format")
    end
    
    def self.time_of_day(time)
      case time.hour
      when 6, 7, 8, 9, 10, 11
        "morning"
      when 12, 13, 14, 15, 16
        "day"
      when 17, 18, 19, 20
        "evening"
      else
        "night"
      end
    end
  end
end