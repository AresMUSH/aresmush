module AresMUSH
  module Rooms
    class LocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        {
          can_manage: Rooms.can_build?(enactor),
          directory: Rooms.area_directory_web_data,
          display_sections: Global.read_config("rooms", "area_display_sections"),
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


