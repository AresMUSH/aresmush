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
    end
  end
end


