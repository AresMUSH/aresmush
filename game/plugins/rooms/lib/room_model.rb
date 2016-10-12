module AresMUSH
  class Character
    reference :room_home, "AresMUSH::Room"
    reference :room_work, "AresMUSH::Room"
  end
  
  class Game
    reference :welcome_room, "AresMUSH::Room"
    reference :ooc_room, "AresMUSH::Room"
    reference :ic_start_room, "AresMUSH::Room"
    
    def is_special_room?(room)
      return true if room == welcome_room
      return true if room == ic_start_room
      return true if room == ooc_room
      return false
    end
  end
  
  
  class Room
    attribute :room_grid_x
    attribute :room_grid_y
    attribute :room_type
    attribute :room_area
    attribute :room_is_foyer, DataType::Boolean
     
    index :room_type
    
    default_values :default_room_attributes
    
    def self.default_room_attributes
      { room_type: "IC" }
    end
    
  end
  
  class Exit    
    attribute :lock_keys, DataType::Array
    
    default_values :default_lock
    
    def self.default_lock
      { lock_keys: [] }
    end
  end
end