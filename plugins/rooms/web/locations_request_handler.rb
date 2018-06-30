module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        {
          areas: Area.all.to_a.sort_by { |a| a.name }.each_with_index.map { |a, index| {
            name: a.name,
            id: a.id,
            description: a.description ? WebHelpers.format_markdown_for_html(a.description) : "",
            show_map: !Global.plugin_manager.is_disabled?("maps"),
            map: get_map(a),
            locations: a.rooms.to_a.sort_by { |r| r.name }.map { |r| {
              name: r.name,
              id: r.id
            }},
            can_manage: Rooms.can_build?(enactor),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
           }},
           orphan_rooms: Room.all.select { |r| !r.area }.sort_by { |r| r.name }.map { |r| 
             { 
               name: r.name,
               id: r.id
             }}
          }
      end
      
      def get_map(area)
        map = Maps.get_map_for_area(area.name)
        
        return nil if !map
        
        { 
          id: map.id,
          text: WebHelpers.format_markdown_for_html(map.map_text)
        }
      end
    end
  end
end


