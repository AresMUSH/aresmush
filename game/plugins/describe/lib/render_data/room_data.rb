module AresMUSH
  module Describe
    class RoomData
      include TemplateFormatters
      
      def initialize(model)
        @model = model
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