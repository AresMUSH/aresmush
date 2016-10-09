module AresMUSH
  class Character
    def timezone
      self.ooctime_timezone
    end
    
    def timezone=(tz)
      self.ooctime_timezone = tz
    end
  end
  
  module OOCTime
    module Api
      def self.local_short_timestr(viewer, datetime)
        OOCTime.local_short_timestr(viewer, datetime)
      end

      def self.local_long_timestr(viewer, datetime)
        OOCTime.local_long_timestr(viewer, datetime)
      end
    end
  end
end