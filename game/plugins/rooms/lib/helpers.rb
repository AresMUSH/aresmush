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
    
  end
end