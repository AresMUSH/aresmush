module AresMUSH
  class Character
    reference :home, "AresMUSH::Room"
    reference :work, "AresMUSH::Room"
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
    
    attribute :grid_x
    attribute :grid_y
    attribute :room_type
    attribute :area
    attribute :is_foyer, DataType::Boolean
        
  end
  
  class Exit
    def lock_keys
      []
    end
    # TODO
    #field :lock_keys, :type => Array, :default => []
    
    def allow_passage?(char)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
  end
end