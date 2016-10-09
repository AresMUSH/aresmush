module AresMUSH
  
  class Room
    def grid_x
      self.room_grid_x
    end
    
    def grid_y
      self.room_grid_y
    end
    
    def area
      self.room_area
    end
    
    def is_foyer?
      self.room_is_foyer
    end
  end
  
  class Exit  
    def allow_passage?(char)
      return false if (self.lock_keys == Rooms.interior_lock)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
  end
  
  module Rooms
    module Api
      def self.move_to(client, char, room, exit_name = nil?)
        Rooms.move_to(client, char, room, exit_name)
      end
    
      def self.is_special_room?(room)
        Game.master.is_special_room?(room)
      end
      
      def self.send_to_welcome_room(client, char)
        Rooms.move_to(client, char, Game.master.welcome_room)
      end
      
      def self.ic_start_room
        Game.master.ic_start_room
      end
      
      def self.ooc_room
        Game.master.ooc_room
      end
    end
  end
end