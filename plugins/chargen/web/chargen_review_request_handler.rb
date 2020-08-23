module AresMUSH
  module Chargen
    class ChargenReviewRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
                
        char = Character.find_one_by_name id
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (!Chargen.can_approve?(enactor))
          if (char != enactor)
            return { error: t('dispatcher.not_allowed') }
          end
          
          error = Chargen.check_chargen_locked(char)
          return { error: error } if error
        end
                
        return Chargen.build_app_review_info(char, enactor)
      end
    end
  end
end


