module AresMUSH
  module Website
    class GetRecentChangesRequestHandler
      def handle(request)
        Website.get_recent_changes
      end
    end
  end
end