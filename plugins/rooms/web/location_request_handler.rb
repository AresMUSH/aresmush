module AresMUSH
  module Rooms
    class LocationRequestHandler
      def handle(request)
        id = request.args['id']
        edit_mode = (request.args['edit_mode'] || "").to_bool
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        room = Room[id]
        if (!room)
          return { error: t('webportal.not_found') }
        end
        
        if (room.room_owners.any?)
          owners = room.room_owners.map { |o| {
            name: o.name, 
            icon: Website.icon_for_char(o)
            }}
        else
          owners = nil
        end
        
        if (edit_mode) 
           desc = Website.format_input_for_html(room.description)
        else
          desc = room.description ? Website.format_markdown_for_html(room.description) : ""
        end        
        
        if (room.area)
          area = {
            name: room.area.name,
            id: room.area.id,
            full_name: room.area.full_name
          }
        else
          area = nil
        end
        
        areas = Area.all.to_a.sort_by { |area| area.full_name }.map { |area|
          {
            name: area.name,
            id: area.id,
            full_name: area.full_name
          }
        }
        
        {
          id: room.id,
          name: room.name,
          descs: edit_mode ? Describe.get_web_descs_for_edit(room) : Describe.get_web_descs_for_display(room),
          summary: edit_mode ? Website.format_input_for_html(room.shortdesc) : Website.format_markdown_for_html(room.shortdesc),
          owners: owners,
          icon_type: room.room_icon,
          icon_display: Rooms.icon_display(room.room_icon),
          area: area,
          name_and_area: room.name_and_area,
          can_edit: enactor && (room.room_owners.include?(enactor) || Rooms.can_build?(enactor)),
          destinations: room.exits.select { |e| e.dest }.map { |e| 
            { 
            name: e.dest.name, 
            id: e.dest.id
            }},
          can_manage: Rooms.can_build?(enactor),
          areas: areas,
          icon_types: Global.read_config('rooms', 'icon_types').keys
        }
      end
      
    end
  end
end


