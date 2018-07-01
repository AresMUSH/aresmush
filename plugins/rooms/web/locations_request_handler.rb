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
          areas: Area.all.to_a.sort_by { |a| a.name }.map { |a| build_area_definition(a) },
          orphan_rooms: Room.all.select { |r| !r.area }.sort_by { |r| r.name }.map { |r| 
             { 
               name: r.name,
               id: r.id
             }}
          }
      end
      
      def build_directory(area)
        {
          name: area.name,
          children: area.children.map { |a| build_directory(a) }
        }
      end
      
      def build_area_definition(area)
        {
          name: area.name,
          id: area.id,
          parent: area.parent ? area.parent.name : nil,
          description: area.description ? WebHelpers.format_markdown_for_html(area.description) : "",
          locations: area.rooms.to_a.sort_by { |r| r.name }.map { |r| {
            name: r.name,
            id: r.id
          }},
          children: area.sorted_children.map { |a| build_area_definition(a) }
         }
      end
    end
  end
end


