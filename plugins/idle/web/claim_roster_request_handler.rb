module AresMUSH
  module Idle
    class ClaimRosterRequestHandler
      def handle(request)
                
        char = Character[request.args[:id]]
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        Idle.claim_roster(char)        
      end
    end
  end
end