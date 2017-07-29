module AresMUSH
  module OOCTime
    
    def self.local_short_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      lt.strftime Global.read_config("date_and_time", "short_date_format")
    end

    def self.local_long_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      lt.strftime Global.read_config("date_and_time", "long_date_format")
    end
    
    def self.localtime(viewer, datetime)
      return "" if !datetime
      setting = viewer ? viewer.timezone : nil
      timezone = Timezone::Zone.new :zone => setting || "America/New_York"
      timezone.time datetime      
    end
    
    def self.parse_datetime(datetime)
      date_format = Global.read_config("date_and_time", "date_and_time_entry_format")
      Time.strptime(datetime, date_format)
    end
    
    def self.format_date_time_for_entry(datetime)
      datetime.strftime Global.read_config("date_and_time", "date_and_time_entry_format")
    end
    
  end
end