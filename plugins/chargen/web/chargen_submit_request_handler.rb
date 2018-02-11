module AresMUSH
  module Chargen
    class ChargenSubmitRequestHandler
      def handle(request)
        char = request.enactor
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        error = Chargen.check_chargen_locked(enactor)
        return error if error
        
        Chargen.submit_app(char)
                
        {    
        }
      end
    end
  end
end


