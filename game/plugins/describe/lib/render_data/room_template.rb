module AresMUSH
  module Describe
    class RoomTemplate
      include TemplateFormatters
    
      attr_accessor :clients, :exits
            
      def initialize(model, clients, exits)
        @model = model
        @clients = clients
        @exits = exits
      end
      
      def name
        @model.name
      end
      
      def description
        @model.description
      end
      
      def ooc_time
        DateTime.now
      end
    end
  end
end