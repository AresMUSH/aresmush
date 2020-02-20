module AresMUSH
  module Idle
    class ClaimRosterRequestHandler
      def handle(request)
                
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
                        
        char = Character[request.args[:id]]
        app = Website.format_input_for_mush((request.args[:app] || ""))
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        Idle.claim_roster(char, enactor, app)    
      end
    end
  end
end