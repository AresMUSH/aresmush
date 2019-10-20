module AresMUSH
  module Rooms
    class LocationRequestHandler
      def handle(request)
        id = request.args[:id]
        edit_mode = (request.args[:edit_mode] || "").to_bool
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
        
        
        {
          name: room.name,
          description: desc,
          owners: owners,
          area: area,
          name_and_area: room.name_and_area,
          destinations: room.exits.select { |e| e.dest }.map { |e| 
            { 
            name: e.dest.name, 
            id: e.dest.id
            }},
          details: room.details.map { |k, v| { name: k, desc: Website.format_markdown_for_html(v) } },
          can_manage: Rooms.can_build?(enactor)
        }
      end
      
    end
  end
end


