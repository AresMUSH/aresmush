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
      template = Describe.desc_template(viewer.room, viewer)
      client.emit template.render
    end
    
    def self.can_build?(actor)
      actor.has_permission?("build")
    end

    def self.can_teleport?(actor)
      actor.has_permission?("teleport")
    end
    
    def self.can_go_home?(actor)
      actor.has_permission?("go_home")
    end    
    
    def self.room_types
      [ 'IC', 'OOC', 'RPR' ]
    end
    
    def self.interior_lock
      [ "INTERIOR_LOCK" ]
    end
    
    def self.clients_in_room(room)
      clients = []
      Global.client_monitor.clients.each do |c|
        char = c.find_char
        if (char && char.room == room)
          clients << c
        end
      end
      clients
    end
    
    def self.emit_to_room(room, message)
      Rooms.clients_in_room(room).each { |c| c.emit message }
    end

    def self.emit_ooc_to_room(room, message)
      Rooms.clients_in_room(room).each { |c| c.emit_ooc message }
    end
  end
end