module AresMUSH
  module Website
    class SearchWikiRequestHandler
      def handle(request)

        searchText = (request.args[:searchText] || "").strip
        searchTag = (request.args[:searchTag] || "").strip
        
        pages = WikiPage.all
        
        if (!searchText.blank?)
          pages = pages.select { |p| "#{p.heading} #{p.text}" =~ /\b#{searchText}\b/i }
        end
        
        if (!searchTag.blank?)
          pages = pages.select { |p| p.tags.include?(searchTag.downcase) }
        end

        pages.sort_by { |p| p.heading }
        .map{ |p| {
          heading: p.heading,
          id: p.name
        }}
      end
    end
  end
end