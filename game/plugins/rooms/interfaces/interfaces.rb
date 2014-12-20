module AresMUSH
  module Rooms
    def self.move_to(client, char, room, exit_name = nil?)
      if (exit_name)
        char.room.emit_ooc t('rooms.char_has_left_through_exit', :name => char.name, :room => room.name, :exit => exit_name)
      else
        char.room.emit_ooc t('rooms.char_has_left', :name => char.name)
      end
      
      room.emit_ooc t('rooms.char_has_arrived', :name => char.name)
      char.room = room
      char.save!
      if (!client.nil?)
        Rooms.emit_here_desc(client)
      end
    end
  end
end