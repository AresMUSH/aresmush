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
  end
end