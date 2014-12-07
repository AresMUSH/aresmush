module AresMUSH
  module Rooms
    def self.move_to(client, char, room)
      char.room.emit_ooc t('rooms.char_has_left', :name => char.name)
      room.emit_ooc t('rooms.char_has_arrived', :name => char.name)
      char.room = room
      char.save!
      if (!client.nil?)
        Rooms.emit_here_desc(client)
      end
    end
  end
end