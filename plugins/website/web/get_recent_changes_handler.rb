module AresMUSH
  module Website
    class GetRecentChangesRequestHandler
      def handle(request)
        enactor = request.enactor
        error = Website.check_login(request, true)
        return error if error
        
        Website.recent_changes(enactor)
      end
    end
  end
end