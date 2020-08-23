module AresMUSH
  module Chargen
    class ChargenSaveRequestHandler
      def handle(request)
        chargen_data = request.args[:char]
        id = request.args[:id]
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
                
        char = Character.find_one_by_name id
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (!Chargen.can_approve?(enactor))
          if (char != enactor)
            return { error: t('dispatcher.not_allowed') }
          end
          
          error = Chargen.check_chargen_locked(char)
          return { error: error } if error
        end

        Global.logger.info "Saving chargen data for #{char.name} by #{enactor.name}."
        alerts = Chargen.save_char(char, chargen_data)
        
        {    
          alerts: alerts
        }
      end
    end
  end
end


