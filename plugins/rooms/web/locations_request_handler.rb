module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        {
          can_manage: Rooms.can_build?(enactor),
          directory: Rooms.top_level_areas.map { |a| build_directory(a) },
          orphan_rooms: Room.all.select { |r| is_orphan?(r) }.sort_by { |r| r.name }.map { |r| 
             { 
               name: r.name,
               id: r.id,
               name_and_area: r.name_and_area,
               description: r.description ? Website.format_markdown_for_html(r.description) : ""
             }}
          }
      end
      
      def build_directory(area)
        {
          id: area.id,
          name: area.name,
          children: area.children.to_a.sort_by { |a| a.name }.map { |a| build_directory(a) }
        }
      end
      
      def is_orphan?(room)
        return false if room.area
        return true if !room.scene
        return !room.scene.temp_room
      end

    end
  end
end


