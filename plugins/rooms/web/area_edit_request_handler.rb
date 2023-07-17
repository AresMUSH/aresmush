module AresMUSH
  module Rooms
    class AreaEditRequestHandler
      def handle(request)
        id = request.args[:id]
        name = request.args[:name]
        desc = request.args[:description]
        summary = request.args[:summary]
        parent_id = request.args[:parent_id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        if (parent_id.blank?)
          parent = nil
        else
          parent = Area[parent_id]
          if (!parent)
            return { error: t('webportal.not_found') }
          end
        end
        
        if (Rooms.has_parent_area(parent, area))
          return { error: t('rooms.circular_area_parentage') }
        end
        
        new_area = Area.find_one_by_name(name)
        if (new_area && (new_area.id != id))
          return { error: t('rooms.area_already_exists', :name => name) }
        end
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        area.update(name: name, 
           description: Website.format_input_for_mush(desc),
           summary: Website.format_input_for_mush(summary),
           parent: parent)
        
        {}
      end
    end
  end
end


