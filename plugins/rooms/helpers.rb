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
    
    def self.area_directory_web_data
      area_order = Global.read_config("rooms", "area_directory_order") || []
      Area.all.to_a.sort_by { |a| [area_order.index(a.name) || 99, a.full_name] }.map{ |area| Rooms.build_area_web_data(area) }
    end
    
    def self.build_area_web_data(area, edit_mode = false)
      display_sections = Global.read_config("rooms", "area_display_sections")
      if (display_sections)
        # Top level - show just base name
        # Level 2 - show just base name (parent, no grandparent)
        # Other levels - show full name
        if (area.grandparent)
          display_name = "#{area.parent.name} - #{area.name}"
        else
          display_name = area.name
        end
      else
        display_name = area.full_name
      end
      
      if (edit_mode) 
         desc = Website.format_input_for_html(area.description)
         summary = Website.format_input_for_html(area.summary)
      else
        desc = area.description ? Website.format_markdown_for_html(area.description) : ""
        if (area.summary.blank?)
          summary = Website.format_markdown_for_html(Rooms.trimmed_desc(area.description, 100))
        else
          summary = Website.format_markdown_for_html(area.summary)
        end
      end
      
      {
        id: area.id,
        name: area.name,
        full_name: area.full_name,
        display_name: display_name,
        summary: summary,
        description: desc,
        children: area.sorted_children.map { |a| Rooms.build_area_web_data(a) },
        parent: area.parent ? { name: area.parent.name, id: area.parent.id } : nil,                
        descendants: area.sorted_descendants.map { |a| Rooms.build_area_web_data(a) },
        rooms: area.rooms.select { |r| !r.is_temp_room? }
          .sort_by { |r| [r.room_icon || 'zzz', r.name] }
          .map { |r| Rooms.build_room_summary_web_data(r) },
        is_top_level: !area.parent
      }
    end
    
    def self.build_room_summary_web_data(room)
      if (room.shortdesc.blank?)
        summary = Website.format_markdown_for_html(Rooms.trimmed_desc(room.description, 100))
      else
        summary =  Website.format_markdown_for_html(room.shortdesc)
      end
      
      { 
        name: room.name, 
        name_and_area: room.name_and_area,
        id: room.id, 
        summary: summary, 
        icon_type: room.room_icon,
        icon_display: Rooms.icon_display(room.room_icon)
      }           
    end
    
    def self.trimmed_desc(desc, length)
      desc = (desc || "")
      shortdesc = desc[0, length]
      if (desc.length > length)
        return "#{shortdesc}..."
      else 
        return shortdesc
      end
    end
    
    def self.icon_display(icon_type)
      return nil if !icon_type
      types = Global.read_config('rooms', 'icon_types') || {}
      types[icon_type] || "fas fa-star"
    end
    
  end
end