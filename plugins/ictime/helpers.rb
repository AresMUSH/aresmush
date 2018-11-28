module AresMUSH
  module ICTime
    def self.ratio_str
      ratio = Global.read_config("ictime", "time_ratio")
      if (ratio >= 1)
        "#{ratio}:1"
      else
        ratio = 1/ratio
        "#{1}:#{ratio.round(1)}"
      end
    end
    
    def self.convert_to_ictime(t)
      day_offset = Global.read_config("ictime", "day_offset")
      hour_offset = Global.read_config("ictime", "hour_offset")
      year = t.year + Global.read_config("ictime", "year_offset")
      ratio = Global.read_config("ictime", "time_ratio")
      
      begin
        if (ratio && ratio != 1)
          start_date = Global.read_config("ictime", "game_start_date")
          if (start_date.blank?)
            raise "Can't specify custom ratio without a start date."
          end

          start = DateTime.strptime(start_date, "%m/%d/%Y")
          delta = t - start
                    
          elapsed = delta * ratio
          t = start + elapsed
          
        end
        
        return DateTime.new(year, t.month, t.day, t.hour, t.minute, t.sec) +  day_offset + hour_offset.hours
        
      rescue Exception => ex
        begin
          # In case we land on an invalid day - like a leap day that doesn't exist - try the next day
          if (t.day > 28)
            return DateTime.new(year, t.month + 1, 1, t.hour, t.minute, t.sec) +  day_offset
          end
        rescue
        end
        Global.logger.error "Error converting RL time to IC time.  Using RL time instead.  Error=#{ex}"
        return t
      end
    end
    
    def self.substitute_ic_names(original_format, time)
      format = "#{original_format}"
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