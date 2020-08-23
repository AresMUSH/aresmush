module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        {
          can_manage: Rooms.can_build?(enactor),
          directory: Area.all.to_a.sort_by { |a| a.full_name }.map{ |area|
            {
              id: area.id,
              name: area.full_name,
              summary: area.summary ? Website.format_markdown_for_html(area.summary) : "",
              children: area.children.to_a.sort_by { |a| a.name }.map { |a| { id: a.id, name: a.name } },
              rooms: area.rooms.select { |r| !r.is_temp_room? }.map { |r| { name: r.name, id: r.id } },
              is_top_level: area.parent ? false : true
            }
          },
          orphan_rooms: Room.all.select { |r| is_orphan?(r) }.sort_by { |r| r.name }.map { |r| 
             { 
               name: r.name,
               id: r.id,
               name_and_area: r.name_and_area
             }}
          }
      end
      
      def is_orphan?(room)
        return false if room.area
        return true if !room.scene
        return !room.is_temp_room?
      end

    end
  end
end


