module AresMUSH
  module Chargen
    class ChargenResetRequestHandler
      def handle(request)
        char = request.enactor
        chargen_data = request.args[:char]
                
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        error = Chargen.check_chargen_locked(char)
        return { error: error } if error
        
        Chargen.save_char(char, chargen_data)
        
        if FS3Skills.is_enabled?
          FS3Skills.reset_char(char)
        end
        
        {          
        }
      end
    end
  end
end


