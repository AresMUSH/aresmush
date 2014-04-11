module AresMUSH
  
  class Game
    field :welcome_room_id, :type => Moped::BSON::ObjectId
    field :ic_start_room_id, :type => Moped::BSON::ObjectId
    field :idle_room_id, :type => Moped::BSON::ObjectId
        
    before_create :create_starting_rooms
    
    def welcome_room
      Room.find(self.welcome_room_id)
    end
    
    def ic_start_room
      Room.find(self.ic_start_room_id)
    end
    
    def idle_room
      Room.find(self.idle_room_id)
    end
    
    def create_starting_rooms  
      Global.logger.debug "Creating start rooms."
      
      welcome_room = AresMUSH::Room.create(:name => "Welcome Room")
      ic_start_room = AresMUSH::Room.create(:name => "IC Start")
      idle_room = AresMUSH::Room.create(:name => "Idle Lounge")
      
      self.welcome_room_id = welcome_room.id
      self.ic_start_room_id = ic_start_room.id
      self.idle_room_id = idle_room.id
    end
  end
  
  class Character
        
    before_create :set_starting_room
    
    def set_starting_room
      Global.logger.debug "Setting starting room."
      
      self.room = Game.master.welcome_room
    end
  end
end