module AresMUSH
  module OOCTime
    module Api
      
      def self.local_short_timestr(client, datetime)
        OOCTime.local_short_timestr(client, datetime)
      end

      def self.local_long_timestr(client, datetime)
        OOCTime.local_long_timestr(client, datetime)
      end
    
      def self.timezone(char)
        char.timezone
      end
    end
  end
end