module AresMUSH
  module Demographics
    class RankCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :chars
      
      def initialize
        super File.dirname(__FILE__) + "/rank_census.erb"
      end
      
      def census
        Demographics.census_by { |c| c.rank }
      end      
    end
  end
end
