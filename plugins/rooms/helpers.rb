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
      actor && actor.has_permission?("build")
    end

    def self.can_teleport?(actor)
      actor && actor.has_permission?("teleport")
    end
    
    def self.can_go_home?(actor)
      actor && actor.has_permission?("go_home")
    end    
    
    def self.room_types
      [ 'IC', 'OOC', 'RPR' ]
    end
    
    def self.interior_lock
      [ "INTERIOR_LOCK" ]
    end
    
    def self.online_chars_in_room(room)
      room.characters.select { |c| Login.is_online?(c) }
    end
    
    def self.find_destination(destination, enactor, allow_char_names = false)
      if (allow_char_names)
        find_result = ClassTargetFinder.find(destination, Character, enactor)
        if (find_result.found?)
          return [find_result.target.room]
        end
      end
        
      find_result = ClassTargetFinder.find(destination, Room, enactor)
      if (find_result.found?)
        return [find_result.target]
      end
      
      matches = Room.find_by_name_and_area destination                
      matches
    end
    
    def self.find_single_room(name, enactor)
      matched_rooms = Rooms.find_destination(name, enactor)
      
      if (matched_rooms == 0)
        return { error: t('db.object_not_found') }
      end
      
      if (matched_rooms.count > 1)
        room_names = matched_rooms.map { |r| r.name_and_area }.join(', ')
        return { error: t('rooms.multiple_rooms_found', :rooms => room_names) }
      end
      
      { room: matched_rooms.first }
    end
    
    def self.top_level_areas
      Area.all.select { |a| !a.parent }.sort_by { |a| a.name }
    end
    
    def self.has_parent_area(parent_to_check, area)
      return false if !parent_to_check
      return false if !parent_to_check.parent
      return true if parent_to_check.parent == area
      Rooms.has_parent_area(parent_to_check.parent, area)
    end
    
    def self.can_delete_area?(area)
      return false if area.children.any?
      return false if area.rooms.any?
      return true
    end
  end
end