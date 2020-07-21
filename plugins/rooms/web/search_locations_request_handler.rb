module AresMUSH
  module Rooms
    class SearchLocationsRequestHandler
      def handle(request)

        search_name = request.args[:searchName] || ""
        search_area = request.args[:searchArea] || ""
        rooms = Room.all.to_a
        
        if (!search_name.blank?)
          rooms = rooms.select { |r| r.name =~ /#{search_name}/i }
        end
        if (!search_area.blank?)
          rooms = rooms.select { |r| (r.area_name || "") =~ /#{search_area}/i }
        end
        
        rooms.sort_by { |r| r.name_and_area }.map { |r| {
                          id: r.id,
                          name: r.name,
                          area_name: r.area_name,
                          area_id: r.area ? r.area.id : nil,
                          name_and_area: r.name_and_area
                        }}
      end
    end
  end
end