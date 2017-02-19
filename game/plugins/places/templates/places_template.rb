module AresMUSH
  module Places
    class PlacesTemplate < ErbTemplateRenderer

      attr_accessor :room
            
      def initialize(room)
        @room = room
        super File.dirname(__FILE__) + "/places.erb"
      end
      
      def character_names(place)
        place.characters.map { |c| c.name }.join(", ")
      end
    end
  end
end