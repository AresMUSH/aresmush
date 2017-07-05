module AresMUSH
  class Room
    collection :places, "AresMUSH::Place"
  end
  
  class Character
    reference :place, "AresMUSH::Place"

    def place_title(viewer)
      return "" if !self.place
      Places.place_title(self.place.name, viewer.place == self.place)
    end
  end
  
  class Place < Ohm::Model
    include ObjectModel
    
    collection :characters, "AresMUSH::Character"
    reference :room, "AresMUSH::Room"
    
    attribute :name
    index :name
  end
end