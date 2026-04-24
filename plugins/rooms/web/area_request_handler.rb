module AresMUSH
  module Rooms
    class AreaRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args['id']
        edit_mode = (request.args['edit_mode'] || "").to_bool
        
        error = Website.check_login(request, true)
        return error if error
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        if (edit_mode && !Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        {
          area: Rooms.build_detailed_area_web_data(area, edit_mode),
          children: area.sorted_children.map { |a| { id: a.id, name: a.name } },
          can_manage: Rooms.can_build?(enactor),
          all_areas: Rooms.area_directory_web_data
        }
      end
    end
  end
end


