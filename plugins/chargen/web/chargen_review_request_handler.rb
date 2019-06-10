module AresMUSH
  module Chargen
    class ChargenReviewRequestHandler
      def handle(request)
        char = request.enactor
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        error = Chargen.check_chargen_locked(char)
        return { error: error } if error
                
        return Chargen.build_app_review_info(char)
      end
    end
  end
end


