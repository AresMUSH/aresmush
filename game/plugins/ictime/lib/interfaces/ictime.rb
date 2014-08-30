module AresMUSH
  module ICTime
    def self.ictime
      t = Date.today
      year = t.year + Global.config['ictime']['year_offset']
      Date.new(year, t.month, t.day) +  Global.config['ictime']['day_offset']
    end
    
    def self.ic_month_str(time)
      time.strftime Global.config["server"]["short_date_format"]
    end
  end
end