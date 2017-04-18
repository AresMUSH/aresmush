module AresMUSH
  module Demographics
    class CompleteCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/complete_census.erb"
      end
      
      def gender(char)
        char.demographic(:gender)
      end
      
      def position(char)
        char.group("Position")
      end
      
      def callsign(char)
        char.demographic(:callsign)
      end
    end
  end
end
