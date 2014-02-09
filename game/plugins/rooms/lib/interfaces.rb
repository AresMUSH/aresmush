module AresMUSH
  module Rooms
    # TODO - Use room obj not id.
    def self.room_emit(loc_id, message, all_clients)
      chars_in_room = all_clients.select { |c| c.char.room_id == loc_id }
      chars_in_room.each { |p| p.emit(message) } 
    end
  end
end