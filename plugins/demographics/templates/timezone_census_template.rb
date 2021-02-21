module AresMUSH
  module Demographics
    class TimezoneCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :chars
      
      def initialize
        super File.dirname(__FILE__) + "/timezone_census.erb"
      end
      
      def census
        Demographics.census_by { |c| "#{OOCTime.utc_offset_display(c)} (#{c.timezone})" }
      end      
    end
  end
end
