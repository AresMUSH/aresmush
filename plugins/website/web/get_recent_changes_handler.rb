module AresMUSH
  module Website
    class GetRecentChangesRequestHandler
      def handle(request)
        Website.recent_changes
      end
    end
  end
end