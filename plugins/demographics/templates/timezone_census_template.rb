module AresMUSH
  module Demographics
    class TimezoneCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :chars
      
      def initialize
        super File.dirname(__FILE__) + "/timezone_census.erb"
      end
      
      def census
        Demographics.census_by { |c| c.timezone }
      end      
    end
  end
end
