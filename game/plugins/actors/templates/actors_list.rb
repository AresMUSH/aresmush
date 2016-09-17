module AresMUSH
  module Actors
    # Template for the list of all bulletin boards.
    class ActorsListTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :paginator
      
      def initialize(paginator, client)
        @paginator = paginator
        super File.dirname(__FILE__) + "/actors_list.erb", client
      end      
    end
  end
end