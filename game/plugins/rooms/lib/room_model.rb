module AresMUSH
  class Character
    before_create :set_starting_room
    belongs_to :home, :class_name => "AresMUSH::Room", :inverse_of => nil
    belongs_to :work, :class_name => "AresMUSH::Room", :inverse_of => nil

    def set_starting_room
      Global.logger.debug "Setting starting room."
      
      self.room = Game.master.welcome_room
      self.home = Game.master.ooc_room
      self.work = Game.master.ooc_room
    end
  end
  
  class Game
    belongs_to :welcome_room, :class_name => "AresMUSH::Room", :inverse_of => nil
    belongs_to :ic_start_room, :class_name => "AresMUSH::Room", :inverse_of => nil
    belongs_to :ooc_room, :class_name => "AresMUSH::Room", :inverse_of => nil
        
    def is_special_room?(room)
      return true if room == welcome_room
      return true if room == ic_start_room
      return true if room == ooc_room
      return false
    end
  end
  
  
  class Room
    
    field :area, :type => String
    field :grid_x, :type => String
    field :grid_y, :type => String
    field :room_type, :type => String, :default => "IC"
    field :is_foyer, :type => Boolean      
    
  end
  
  class Exit
    field :lock_keys, :type => Array, :default => []
    
    def allow_passage?(char)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
  end
end