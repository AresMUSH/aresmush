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
      desc = Describe.get_desc(client.room)
      client.emit(desc)
    end
  end
end