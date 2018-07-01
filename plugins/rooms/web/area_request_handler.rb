module AresMUSH
  module Rooms
    class AreaRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        edit_mode = request.args[:edit_mode].to_bool
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        if (edit_mode && !Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                  
        {
          id: id,
          name: area.name,
          description: edit_mode ? WebHelpers.format_input_for_html(area.description) : WebHelpers.format_markdown_for_html(area.description)
        }
      end
    end
  end
end


