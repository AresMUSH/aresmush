module AresMUSH
  class Room
    collection :places, "AresMUSH::Place"
  end
  
  class Character
    reference :place, "AresMUSH::Place"
  end
  
  class Place < Ohm::Model
    include ObjectModel
    
    collection :characters, "AresMUSH::Character"
    reference :room, "AresMUSH::Room"
    
    attribute :name
    index :name
  end
end