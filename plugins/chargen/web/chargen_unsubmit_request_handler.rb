module AresMUSH
  module Chargen
    class ChargenUnsubmitRequestHandler
      def handle(request)
        char = request.enactor
                
        if (!char)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (char.is_approved?)
          return { error: "You have already completed character creation." }
        end
        
        if (!char.chargen_locked)
          return { error: "Your character is not submitted." }
        end
        
        Chargen.unsubmit_app(char)
                
        {    
        }
      end
    end
  end
end


