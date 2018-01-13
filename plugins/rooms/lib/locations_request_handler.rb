module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        Room.all.group_by { |r| r.area }.sort_by { |area, rooms| area || "" }.map { |area, rooms| {
          area: area,
          map: AresMUSH::Maps.is_enabled? ? AresMUSH::Maps.get_map_for_area(area) : nil,
          locations: rooms.sort_by { |r| r.name || "" }.map { |r| {
            name: r.name,
            id: r.id
          }}
        }}
      end
    end
  end
end


