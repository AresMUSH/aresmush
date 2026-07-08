module AresMUSH
  module Chargen
    class ChargenSubmitRequestHandler
      def handle(request)
        id = request.args['char_id']
        app_notes = request.args['app_notes']
        enactor = request.enactor
        
        char = Character.find_one_by_name id
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        error = Chargen.check_chargen_locked(char)
        return { error: error } if error
  
        if (enactor == char)
          can_submit = Chargen.can_submit_app?(enactor)
        else
          can_submit = Chargen.can_manage_apps?(enactor)
        end
        
         if !can_submit
          return { error: t('chargen.app_not_allowed') }
        end
        
        Chargen.submit_app(char, app_notes)
                
        {    
        }
      end
    end
  end
end


