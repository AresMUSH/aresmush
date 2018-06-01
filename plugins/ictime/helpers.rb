module AresMUSH
  module ICTime
    def self.substitute_ic_names(format, time)
      month_names = Global.read_config("ictime", "month_names") 
      day_names = Global.read_config("ictime", "day_names")
                      
      if (month_names && !month_names.empty?)
        month = month_names[time.month - 1] || ""
        month_abbr = month[0,3]
        subs = { "%B" => month, "%b" => month_abbr, "%h" => month_abbr, "%^B" => month.upcase, "%^b" => month_abbr.upcase }
        
        subs.each do |m, s|
          format.gsub!(m, s)
        end
      end
      
      if (day_names && !day_names.empty?)
        day = day_names[time.wday - 1] || ""
        day_abbr = day[0,3]
        subs = { "%A" => day, "%a" => day_abbr, "%^A" => day.upcase, "%^a" => day_abbr.upcase }
        
        subs.each do |m, s|
          format.gsub!(m, s)
        end
      end      
      
      format
    end
    
  end
end