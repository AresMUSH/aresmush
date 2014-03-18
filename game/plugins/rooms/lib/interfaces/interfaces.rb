module AresMUSH
  module Rooms
    def self.move_to(client, room)
      client.room.emit_ooc "#{client.name} has left."
      room.emit_ooc "#{client.name} has arrived."
      client.char.room = room
      client.char.save!
      client.emit_ooc "You go to #{room.name}."
      client.emit Describe.get_desc(room)
    end
  end
end