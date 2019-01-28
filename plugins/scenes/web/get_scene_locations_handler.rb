module AresMUSH
  module Scenes
    class GetSceneLocationsHandler
      def handle(request)

        scene = Scene[request.args[:id]]
        enactor = request.enactor
      
        error = Website.check_login(request, true)
        return error if error

        area_name = nil
        if (scene && scene.room)
          area_name = scene.room.area_name
        end
        
        Room.all.select { |r| r.room_type == "IC" }
          .sort_by { |r| [(r.area_name == area_name) ? 0 : 1, r.name] }
          .map { |r| r.name_and_area }
        
      end
    end
  end
end