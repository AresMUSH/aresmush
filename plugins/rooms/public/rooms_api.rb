module AresMUSH
  module Rooms
    
    def self.move_to(client, char, room, exit_name = nil)
      current_room = char.room
      if (current_room)
        Status.update_last_ic_location(char)
        Places.clear_place(char)
      end
      
      if (exit_name)
        current_room.emit_ooc t('rooms.char_has_left_through_exit', :name => char.name, :room => room.name, :exit => exit_name)
      else
        current_room.emit_ooc t('rooms.char_has_left', :name => char.name)
      end
      
      char.update(room: room)
      if (client)
        Rooms.emit_here_desc(client, char)
      end
      
      room.emit_ooc t('rooms.char_has_arrived', :name => char.name)
    end
    
    def self.is_special_room?(room)
      Game.master.is_special_room?(room)
    end
      
    def self.send_to_welcome_room(client, char)
      Rooms.move_to(client, char, Game.master.welcome_room)
    end

    def self.send_to_ooc_room(client, char)
      Rooms.move_to(client, char, Game.master.ooc_room)
    end
      
    def self.ic_start_room
      Game.master.ic_start_room
    end
      
    def self.ooc_room
      Game.master.ooc_room
    end
    
    # Deprecated - use room.clients instead
    def self.clients_in_room(room)	
      room.clients
    end	
    
    # Deprecated - use room.emit instead
    def self.emit_to_room(room, message)	
      room.emit(message)
    end	
    
    # Deprecated - use room.emit_ooc instead
    def self.emit_ooc_to_room(room, message)	
      room.emit_ooc(message)
    end
    
  end
end