module AresMUSH
  module Rooms
    def self.room_emit(loc_id, message, all_clients)
      chars_in_room = all_clients.select { |c| c.char["location"] == loc_id }
      chars_in_room.each { |p| p.emit(message) } 
    end
  end
end