module AresMUSH
  module OOCTime
    
    def self.local_short_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      lt.strftime Global.read_config("datetime", "short_date_format")
    end

    def self.local_long_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      lt.strftime Global.read_config("datetime", "long_date_format")
    end
    
    def self.localtime(viewer, datetime)
      return "" if !datetime
      setting = viewer ? viewer.timezone : nil
      timezone = Timezone::Zone.new :zone => setting || "America/New_York"
      timezone.time datetime      
    end
    
    def self.parse_datetime(datetime)
      Time.strptime(datetime, OOCTime.date_and_time_entry_format)
    end
    
    def self.format_date_time_for_entry(datetime)
      datetime.strftime OOCTime.date_and_time_entry_format
    end
    
    def self.date_and_time_entry_format
      date_format = Global.read_config("datetime", "short_date_format")
      time_format = Global.read_config("datetime", "time_format")
      "#{date_format} #{time_format}"
    end
  end
end