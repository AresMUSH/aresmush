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
        char.demographic(:gender)
      end
      
      def position(char)
        char.group_value("Position")
      end
    end
  end
end
