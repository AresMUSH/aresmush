module AresMUSH
  module ICTime
    def self.ictime
      t = DateTime.now
      year = t.year + Global.config['ictime']['year_offset']
      DateTime.new(year, t.month, t.day, t.hour, t.minute, t.sec) +  Global.config['ictime']['day_offset']
    end
    
    # Used in certain places where you don't want to display the full date and time
    # and just want a shorter version - typically just month/day/year
    def self.ic_datestr(time)
      ICTime.ic_short_timestr(time)
    end
    
    def self.ic_short_timestr(time)
      time.strftime Global.config["date_and_time"]["short_date_format"]
    end
    
    def self.ic_long_timestr(time)
      time.strftime Global.config["date_and_time"]["long_date_format"]
    end
  end
end