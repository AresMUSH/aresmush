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
    attribute :room_type, :default => "IC"
    attribute :room_area
    attribute :room_is_foyer, :type => DataType::Boolean
    
    # Room owner is just the ID, but it's not named "_id" to prevent builders
    # from seeing all character details on examine.
    attribute :room_owner
         
    index :room_type
    
    def grid_x
      self.room_grid_x
    end
    
    def grid_y
      self.room_grid_y
    end
    
    def area
      self.room_area
    end
    
    def is_foyer?
      self.room_is_foyer
    end
    
    def owned_by?(char)
      self.room_owner == char.id
    end
    
    def self.find_by_name_and_area(search, enactor_room = nil)
      return [enactor_room] if search == "here" && enactor_room
      Room.all.select { |r| r.format_room_name_for_area_match(search) == (search || "").upcase }
    end
    
    def format_room_name_for_area_match(search)
      if (search =~ /\//)
        return "#{self.area}/#{self.name}".upcase
      else
        return self.name.upcase
      end
    end
  end
  
  class Exit    
    attribute :lock_keys, :type => DataType::Array, :default => []
    
    def allow_passage?(char)
      return false if (self.lock_keys == Rooms.interior_lock)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
  end
end