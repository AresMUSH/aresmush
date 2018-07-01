module AresMUSH
  module Rooms
    class AreaTemplate < ErbTemplateRenderer
             
      attr_accessor :area
                     
      def initialize(area)
        @area = area
        super File.dirname(__FILE__) + "/area.erb"        
      end
      
      def locations
        self.area.rooms
      end
    end
  end
  
end