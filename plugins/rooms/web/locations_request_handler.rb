module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        {
          can_manage: Rooms.can_build?(enactor),
          directory: Rooms.top_level_areas.map { |a| build_directory(a) },
          orphan_rooms: Room.all.select { |r| !r.area }.sort_by { |r| r.name }.map { |r| 
             { 
               name: r.name,
               id: r.id,
               description: r.description ? WebHelpers.format_markdown_for_html(r.description) : ""
             }}
          }
      end
      
      def build_directory(area)
        {
          id: area.id,
          name: area.name,
          children: area.children.map { |a| build_directory(a) }
        }
      end

    end
  end
end


