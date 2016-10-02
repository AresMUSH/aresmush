module AresMUSH
  module Rooms
    def self.open_exit(name, source, dest)
      if (source.has_exit?(name))
        return t('rooms.exit_already_exists')
      end
      AresMUSH::Exit.create(:name => name, :source => source, :dest => dest)
      return t('rooms.exit_created', :source_name => source.name, :dest_name => !dest ? t('rooms.nowhere') : dest.name)
    end
    
    def self.emit_here_desc(client, viewer)        
      template = Describe::Api.desc_template(viewer.room, viewer)
      client.emit template.render
    end
    
    def self.can_build?(actor)
      actor.has_any_role?(Global.read_config("rooms", "roles", "can_build"))
    end

    def self.can_teleport?(actor)
      actor.has_any_role?(Global.read_config("rooms", "roles", "can_teleport"))
    end
    
    def self.can_go_home?(actor)
      actor.has_any_role?(Global.read_config("rooms", "roles", "can_go_home"))
    end
    
    def self.room_types
      [ 'IC', 'OOC' ]
    end
    
    def self.interior_lock
      [ "INTERIOR_LOCK" ]
    end
    
    def self.move_to(client, char, room, exit_name = nil?)
      current_room = char.room
      
      if (exit_name)
        current_room.emit_ooc t('rooms.char_has_left_through_exit', :name => char.name, :room => room.name, :exit => exit_name)
      else
        current_room.emit_ooc t('rooms.char_has_left', :name => char.name)
      end
      
      char.room = room
      if (client)
        Rooms.emit_here_desc(client, char)
      end
      
      char.save
      room.emit_ooc t('rooms.char_has_arrived', :name => char.name)
    end
  end
end