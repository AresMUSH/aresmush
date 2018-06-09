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
    
    def self.is_night?(area)
      ICTime.time_of_day(area) == "night"
    end
    
    def self.is_day?(area)
      ICTime.time_of_day(area) != "night"
    end
    
    def self.time_of_day(area)
      # Area is not currently used; all areas assumed to be on same day/night cycle.
      # You can change this with custom code.
      time = ICTime.ictime
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
    
    def self.season(area)
      time = ICTime.ictime
      day_hash = time.month * 100 + time.mday
      case day_hash
        when 101..401 then 'winter'
        when 402..630 then 'spring'
        when 701..930 then 'summer'
        when 1001..1231 then 'fall'
      end
    end
  end
end