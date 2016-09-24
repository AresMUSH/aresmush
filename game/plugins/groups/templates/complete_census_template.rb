module AresMUSH
  module Groups
    class CompleteCensusTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/complete_census.erb"
      end
      
      def gender(char)
        Demographics::Api.gender(char)
      end
      
      def position(char)
        char.groups["Position"]
      end
    end
  end
end
