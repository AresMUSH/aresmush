module AresMUSH
  module Rooms
    class LocationDeleteRequestHandler
      def handle(request)
        id = request.args['id']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request       
        
        room = Room[id]
        if (!room)
          return { error: t('webportal.not_found') }
        end
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (Rooms.is_special_room?(target))
          return { error: t('manage.cannot_destroy_special_rooms') }
        end
        
        Global.logger.info "#{enactor.name} deleted #{room.name}."
        
        room.delete
        
        {}
      end
    end
  end
end


