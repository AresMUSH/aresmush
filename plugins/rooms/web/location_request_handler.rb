module AresMUSH
  module Rooms
    class LocationRequestHandler
      def handle(request)
        id = request.args[:id]
        
        room = Room[id]
        if (!room)
          return { error: t('webportal.not_found') }
        end
        
        {
          id: id,
          name: room.name,
          area: room.area_name,
          description: WebHelpers.format_markdown_for_html(room.description || "No description set." )
        }
      end
    end
  end
end


