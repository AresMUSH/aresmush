module AresMUSH
  module ICTime
    def self.ictime
      t = Date.today
      year = t.year + Global.config['ictime']['year_offset']
      Date.new(year, t.month, t.day) +  Global.config['ictime']['day_offset']
    end
    
    # Used in certain places where you don't want to display the full date and time
    # and just want a shorter version - typically just month/day/year
    def self.ic_datestr(time)
      time.strftime Global.config["date_and_time"]["short_date_format"]
    end
  end
end