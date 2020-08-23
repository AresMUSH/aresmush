module AresMUSH
  module Rooms
    class AreaDeleteRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Rooms.can_delete_area?(area))
          return { error: t('rooms.cant_delete_area') }
        end
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        area.delete
        
        {}
      end
    end
  end
end


