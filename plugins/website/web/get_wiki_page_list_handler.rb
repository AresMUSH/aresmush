module AresMUSH
  module Website
    class GetWikiPageListRequestHandler
      def handle(request)
        WikiPage.all.to_a
        .sort_by { |p| p.heading }
        .map{ |p| {
          heading: p.heading,
          id: p.name
        }}
      end
    end
  end
end