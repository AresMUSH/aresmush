module AresMUSH
  module Groups
    class GenderCensusTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :chars
      
      def initialize
        super File.dirname(__FILE__) + "/gender_census.erb"
      end
      
      def census
        Groups.census_by { |c| Demographics::Api.demographic(c, :gender) }
      end      
    end
  end
end
