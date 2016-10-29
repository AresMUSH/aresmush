module AresMUSH
  module ICTime
    module Api

      def self.ictime
        ICTime.ictime
      end
  
      # Used in certain places where you don't want to display the full date and time
      # and just want a shorter version - typically just month/day/year
      def self.ic_datestr(time)
        ICTime.ic_short_timestr(time)
      end
    
      def self.ic_short_timestr(time)
        ICTime.ic_short_timestr(time)
      end
    
      def self.ic_long_timestr(time)
        ICTime.ic_long_timestr(time)
      end
    
      def self.time_of_day(time)
        ICTime.time_of_day(time)
      end
    end
  end
end