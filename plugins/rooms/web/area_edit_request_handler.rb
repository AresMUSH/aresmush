module AresMUSH
  module Rooms
    class AreaEditRequestHandler
      def handle(request)
        id = request.args[:id]
        name = request.args[:name]
        desc = request.args[:description]
        map = request.args[:map]
        enactor = request.enactor
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        if (map)
          map = GameMap[map]
        else
          map = nil
        end
        
        area.update(name: name, description: WebHelpers.format_input_for_mush(desc), map: map)
        
        {}
      end
    end
  end
end


