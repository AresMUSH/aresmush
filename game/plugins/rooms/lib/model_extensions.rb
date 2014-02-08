module AresMUSH
  
  class Game
    key :welcome_room_id, ObjectId
    key :ic_start_room_id, ObjectId
    key :idle_room_id, ObjectId
  end
  
end