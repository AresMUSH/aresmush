module AresMUSH
  module Actors
    # Template for the list of all bulletin boards.
    class ActorsListTemplate < ErbTemplateRenderer      
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/actors_list.erb"
      end      
    end
  end
end