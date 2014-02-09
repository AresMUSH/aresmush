module AresMUSH
  
  class Game
    key :welcome_room_id, ObjectId
    key :ic_start_room_id, ObjectId
    key :idle_room_id, ObjectId
        
    before_create :create_starting_rooms
    
    def welcome_room
      Room.find(@welcome_room_id)
    end
    
    def ic_start_room
      Room.find(@ic_start_room_id)
    end
    
    def idle_room
      Room.find(@idle_room_id)
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