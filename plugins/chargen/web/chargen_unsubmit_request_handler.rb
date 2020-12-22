module AresMUSH
  module Chargen
    class ChargenUnsubmitRequestHandler
      def handle(request)
        char = request.enactor
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (char.is_approved?)
          return { error: t('chargen.you_are_already_approved')}
        end
        
        if (!char.chargen_locked)
          return { error: t('chargen.you_have_not_submitted_app') }
        end
        
        Chargen.unsubmit_app(char)
                
        {    
        }
      end
    end
  end
end


