module AresMUSH
  module Website
    class GetRecentChangesRequestHandler
      def handle(request)
        WebHelpers.get_recent_changes
      end
    end
  end
end