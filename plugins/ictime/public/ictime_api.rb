module AresMUSH
  module ICTime
    def self.ictime
      t = DateTime.now
      ICTime.convert_to_ictime(t)
    end
    
    # Used in certain places where you don't want to display the full date and time
    # and just want a shorter version - typically just month/day/year
    def self.ic_datestr(time)
      ICTime.ic_short_timestr(time)
    end
        
    def self.ic_short_timestr(time)
      format = Global.read_config("datetime", "short_date_format")
      format = substitute_ic_names(format, time)
      l(time, format: format)
    end
  
    def self.ic_long_timestr(time)
      format = Global.read_config("datetime", "long_date_format")
      format = substitute_ic_names(format, time)
      l(time, format: format)
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