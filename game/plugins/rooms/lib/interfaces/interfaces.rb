module AresMUSH
  module Rooms
    def self.move_to(client, room)
      client.room.emit_ooc t('rooms.char_has_left', :name => client.name)
      room.emit_ooc t('rooms.char_has_arrived', :name => client.name)
      client.char.room = room
      client.char.save!
      Rooms.emit_here_desc(client)
    end
  end
end