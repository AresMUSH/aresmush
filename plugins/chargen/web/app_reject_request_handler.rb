module AresMUSH
  module Chargen
    class AppRejectRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name request.args[:id]
        notes = request.args[:notes]
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!Chargen.can_approve?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        error = Chargen.reject_char(enactor, char, notes)
        if (error)
          return { error: error }
        end
          
        {
        }
      end
    end
  end
end


