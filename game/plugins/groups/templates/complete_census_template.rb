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
        Demographics::Api.demographic(char, :gender)
      end
      
      def position(char)
        char.group("Position")
      end
    end
  end
end
