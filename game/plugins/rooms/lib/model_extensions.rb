module AresMUSH
  
  class Game
    key :welcome_room_id, ObjectId
    key :ic_start_room_id, ObjectId
    key :idle_room_id, ObjectId
    
    after_create :create_starting_rooms
    
    def create_starting_rooms  
      welcome = AresMUSH::Room.create("name" => "Welcome Room")
      ic = AresMUSH::Room.create("name" => "IC Start")
      idle = AresMUSH::Room.create("name" => "Idle Lounge")
    
      @welcome_room_id = welcome[:_id]
      @ic_start_room_id = ic[:_id]
      @idle_room_id = idle[:_id]
    end
  end
  
  #class Character
  #  
  #  key :location_id, ObjectId
  #  
  #  after_create :set_starting_location
  #  
  #  def set_starting_location(client)
  #    @location_id = Game.master.welcome_room_id
  #  end
  #  
  #end
  
end