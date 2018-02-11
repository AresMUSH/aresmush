module AresMUSH
  module Chargen
    class ChargenResetRequestHandler
      def handle(request)
        char = request.enactor
        chargen_data = request.args[:char]
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        error = Chargen.check_chargen_locked(enactor)
        return error if error
        
        Chargen.save_char(char, chargen_data)
        FS3Skills.reset_char(nil, char)
        
        {          
        }
      end
    end
  end
end


