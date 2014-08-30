module AresMUSH
  module ICTime
    def self.ictime
      t = Date.today
      year = t.year + Global.config['ictime']['year_offset']
      Date.new(year, t.month, t.day) +  Global.config['ictime']['day_offset']
    end
    
    def self.month_str
      ictime.strftime Global.config["server"]["short_date_format"]
    end
  end
end