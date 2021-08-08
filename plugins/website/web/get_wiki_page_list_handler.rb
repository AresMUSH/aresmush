module AresMUSH
  module Website
    class GetWikiPageListRequestHandler
      def handle(request)
        all_pages = WikiPage.all.to_a
          .sort_by { |p| p.heading }
          .map{ |p| {
            heading: p.heading,
            id: p.name
          }}
        category_pages = WikiPage.all
          .group_by { |p| p.category }
          .map { |category, pages | 
          {
            name: category.blank? ? "(uncategorized)" : category,
            pages: pages.sort_by { |p| p.heading }.map { |p| {
              heading: p.heading,
              id: p.name
            }}
          }}
        
        {
          all: all_pages,
          categories: category_pages
        }
      end
    end
  end
end