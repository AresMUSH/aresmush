module AresMUSH
  module Rooms
    class ManageLocationsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        {
          can_manage: Rooms.can_build?(enactor),
          areas: Rooms.area_directory_web_data,
          icon_types: Global.read_config('rooms', 'icon_types').keys
        }          
      end
    end
  end
end


