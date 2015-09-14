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
      template = Describe.get_desc_template(client.room, client)
      template.render
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
  end
end