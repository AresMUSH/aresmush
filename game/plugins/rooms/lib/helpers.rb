module AresMUSH
  module Rooms
    def self.open_exit(name, source, dest)
      if (source.has_exit?(name))
        return t('rooms.exit_already_exists')
      end
      AresMUSH::Exit.create(:name => name, :source => source, :dest => dest)
      return t('rooms.exit_created', :source_name => source.name, :dest_name => dest.nil? ? t('rooms.nowhere') : dest.name)
    end
    
    def self.emit_here_desc(client)        
      template = Describe::Api.desc_template(client.room, client)
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
      if (exit_name)
        char.room.emit_ooc t('rooms.char_has_left_through_exit', :name => char.name, :room => room.name, :exit => exit_name)
      else
        char.room.emit_ooc t('rooms.char_has_left', :name => char.name)
      end
      
      room.emit_ooc t('rooms.char_has_arrived', :name => char.name)
      char.room = room
      char.save
      if (!client.nil?)
        Rooms.emit_here_desc(client)
      end
    end
  end
end