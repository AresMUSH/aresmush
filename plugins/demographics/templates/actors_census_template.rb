module AresMUSH
  module Demographics
    class ActorsCensusTemplate < ErbTemplateRenderer      
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/actors_census_template.erb"
      end      
    end
  end
end