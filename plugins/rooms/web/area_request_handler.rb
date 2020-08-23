module AresMUSH
  module Rooms
    class AreaRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        edit_mode = (request.args[:edit_mode] || "").to_bool
        
        error = Website.check_login(request, true)
        return error if error
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        if (edit_mode && !Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        if (edit_mode) 
           desc = Website.format_input_for_html(area.description)
           summary = Website.format_input_for_html(area.summary)
        else
          desc = area.description ? Website.format_markdown_for_html(area.description) : ""
          summary = area.summary ? Website.format_markdown_for_html(area.summary) : ""
        end
        
        {
          area: { 
            full_name: area.full_name,
            name: area.name,
            id: area.id,
            parent: area.parent ? { name: area.parent.name, id: area.parent.id } : nil,
            summary: summary,
            description: desc,
            rooms: area.rooms.select { |r| !r.is_temp_room? }.sort_by { |r| r.name }.map { |r| {
              name: r.name,
              id: r.id,
              name_and_area: r.name_and_area
            }},
          children: area.sorted_children.map { |a| { id: a.id, name: a.name } }
        },
          can_manage: Rooms.can_build?(enactor)
        }
        
      end
    end
  end
end


