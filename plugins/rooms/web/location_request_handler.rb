module AresMUSH
  module Rooms
    class LocationRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        {
          area: build_area_definition(area),
          can_manage: Rooms.can_build?(enactor),
          directory: Rooms.top_level_areas.map { |a| build_directory(a) }
        }
      end
      
      def build_area_definition(area)
        { 
          name: area.name,
          id: area.id,
          parent: area.parent ? { name: area.parent.name, id: area.parent.id } : nil,
          description: area.description ? Website.format_markdown_for_html(area.description) : "",
          locations: area.rooms.to_a.sort_by { |r| r.name }.map { |r| {
            name: r.name,
            id: r.id,
            name_and_area: r.name_and_area,
            description: r.description ? Website.format_markdown_for_html(r.description) : ""
            }},
          children: area.sorted_children.map { |a| build_area_definition(a) }
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


