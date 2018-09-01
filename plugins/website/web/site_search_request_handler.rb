module AresMUSH
  module Website
    class SiteSearchRequestHandler
      def handle(request)
        search = request.args[:search]
        
        search_result =  Website.search(search)
        
        results = search_result.sort_by { |data| data[:name] }

        {
          term: search,
          results: results
        }
        
      end
    end
  end
end