module AresMUSH
  module Rooms
    class AreaCreateRequestHandler
      def handle(request)
        name = request.args[:name]
        desc = request.args[:description]
        summary = request.args[:summary]
        parent_id = request.args[:parent_id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        new_area = Area.find_one_by_name(name)
        if (new_area)
          return { error: t('rooms.area_already_exists', :name => name) }
        end
        
        if (parent_id.blank?)
          parent = nil
        else
          parent = Area[parent_id]
          if (!parent)
            return { error: t('webportal.not_found') }
          end
        end
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "name") }
        end

        area = Area.create(name: name, 
           description: Website.format_input_for_mush(desc),
           summary: Website.format_input_for_mush(summary),
           parent: parent)
        
        {
          id: area.id
        }
      end
    end
  end
end


