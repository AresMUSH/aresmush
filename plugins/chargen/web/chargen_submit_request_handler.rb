module AresMUSH
  module Chargen
    class ChargenSubmitRequestHandler
      def handle(request)
        char = request.enactor
        app_notes = request.args[:app_notes]
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        error = Chargen.check_chargen_locked(char)
        return { error: error } if error
        
        Chargen.submit_app(char, app_notes)
                
        {    
        }
      end
    end
  end
end


