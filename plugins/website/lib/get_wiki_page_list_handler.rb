module AresMUSH
  module Website
    class GetWikiPageListRequestHandler
      def handle(request)
        WikiPage.all.to_a
        .sort_by { |p| p.display_title }
        .map{ |p| {
          heading: p.display_title,
          id: p.name
        }}
      end
    end
  end
end