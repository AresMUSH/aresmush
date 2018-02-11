module AresMUSH
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
end