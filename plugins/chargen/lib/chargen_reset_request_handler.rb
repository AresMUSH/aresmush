module AresMUSH
  module Chargen
    class ChargenResetRequestHandler
      def handle(request)
        char = request.enactor
        chargen_data = request.args[:char]
                
        if (!char)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (char.is_approved?)
          return { error: "You have already completed character creation." }
        end
        
        if (char.chargen_locked)
          return { error: "Your character is locked from changes while your application is being reviewed.  Unsubmit your app in-game if you want to make changes." }
        end
        
        Chargen.save_char(char, chargen_data)
        FS3Skills.reset_char(nil, char)
        
        {          
        }
      end
    end
  end
end


