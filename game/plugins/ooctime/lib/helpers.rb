module AresMUSH
  module OOCTime
    def self.localtime(viewer, datetime)
      return "" if !datetime
      timezone = Timezone::Zone.new :zone => !viewer ? "America/New_York" : timezone(viewer)
      timezone.time datetime
    end
    
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
    
    def self.timezone(char)
      prefs = char.time_prefs
      prefs ? prefs.timezone : "America/New_York"
    end
  end
end