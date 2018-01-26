module AresMUSH
  module Chargen
    class ChargenSaveRequestHandler
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
          return { error: "Your character is locked from changes while your application is being reviewed." }
        end
                
        alerts = Chargen.save_char(char, chargen_data)
        
        {    
          alerts: alerts
        }
      end
    end
  end
end


