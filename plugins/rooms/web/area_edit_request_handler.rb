module AresMUSH
  module Rooms
    class AreaEditRequestHandler
      def handle(request)
        id = request.args[:id]
        name = request.args[:name]
        desc = request.args[:description]
        summary = request.args[:summary]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        area = Area[id]
        if (!area)
          return { error: t('webportal.not_found') }
        end
        
        if (!Rooms.can_build?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        area.update(name: name, 
           description: Website.format_input_for_mush(desc),
           summary: Website.format_input_for_mush(summary))
        
        {}
      end
    end
  end
end


