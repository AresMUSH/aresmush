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
    include FindByName
    
    collection :characters, "AresMUSH::Character"
    reference :room, "AresMUSH::Room"
    
    attribute :name
    attribute :name_upcase
    index :name_upcase
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
  end
end