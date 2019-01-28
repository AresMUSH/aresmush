module AresMUSH
  class Game
    reference :welcome_room, "AresMUSH::Room"
    reference :ooc_room, "AresMUSH::Room"
    reference :ic_start_room, "AresMUSH::Room"
    reference :quiet_room, "AresMUSH::Room"
    
    def is_special_room?(room)
      return true if room == welcome_room
      return true if room == ic_start_room
      return true if room == ooc_room
      return true if room == quiet_room
      return false
    end
  end
end