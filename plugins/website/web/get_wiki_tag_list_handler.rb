module AresMUSH
  module Website
    class GetWikiTagListRequestHandler
      def handle(request)
        ContentTag.all.map { |t| t.name }.uniq.sort
      end
    end
  end
end