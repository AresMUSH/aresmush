module AresMUSH
  module Rooms
    class SearchLocationsRequestHandler
      def handle(request)

        searchName = request.args[:searchName] || ""
        searchDesc = request.args[:searchDesc] || ""
        
        rooms = Room.all.to_a
        
        if (!searchName.blank?)
          rooms = rooms.select { |r| r.name =~ /#{searchName}/i }
        end
        pp searchDesc
        if (!searchDesc.blank?)
          rooms = rooms.select { |r| r.description =~ /#{searchDesc}/i }
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