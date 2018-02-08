module AresMUSH
  class Character
    reference :room_home, "AresMUSH::Room"
    reference :room_work, "AresMUSH::Room"
    
    before_save :check_for_nil_room
    
    def check_for_nil_room
      # Characters should never ever be allowed to have a nil room.
      if (!self.room)
        reset_room = Game.master.ic_start_room || Room.all.first
        self.update(room: reset_room)
      end
    end
  end
end