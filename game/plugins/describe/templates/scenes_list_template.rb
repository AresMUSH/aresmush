module AresMUSH
  module Describe
    # Template for a room.
    class SceneListTemplate < ErbTemplateRenderer
      include TemplateFormatters
             
      attr_accessor :rooms
                     
      def initialize(rooms)
        @rooms = rooms
        super File.dirname(__FILE__) + "/scenes_list.erb"        
      end
      
      def characters(room)
        room.characters.map{ |c| c.name }.join(" ")
      end
    end
  end
end