module AresMUSH
  class Character
    reference :room_home, "AresMUSH::Room"
    reference :room_work, "AresMUSH::Room"
    
    before_save :check_for_nil_room
    before_delete :clear_owners
    
    def check_for_nil_room
      # Characters should never ever be allowed to have a nil room.
      if (!self.room)
        reset_room = Game.master.ic_start_room || Room.all.first
        self.update(room: reset_room)
      end
    end
    
    def clear_owners
      Room.all.each do |r|
        Database.remove_from_set r.room_owners, self
      end
    end
  end
end