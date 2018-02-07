module AresMUSH
  module Chargen
    class ChargenSaveRequestHandler
      def handle(request)
        char = request.enactor
        chargen_data = request.args[:char]
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        error = Chargen.check_chargen_locked(char)
        return error if error
                
        alerts = Chargen.save_char(char, chargen_data)
        
        {    
          alerts: alerts
        }
      end
    end
  end
end


