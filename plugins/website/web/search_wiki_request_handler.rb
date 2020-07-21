module AresMUSH
  module Website
    class SearchWikiRequestHandler
      def handle(request)

        search_text = (request.args[:searchText] || "").strip
        search_title = (request.args[:searchTitle] || "").strip
        search_tag = (request.args[:searchTag] || "").strip
        search_category = (request.args[:searchCategory] || "").strip
        
        pages = WikiPage.all.to_a

        if (!search_category.blank?)
          pages = pages.select { |p| p.name.downcase.start_with?("#{search_category.downcase}:") }
        end
                
        if (!search_title.blank?)
          pages = pages.select { |p| "#{p.heading.downcase}" =~ /#{search_title.downcase}/i }
        end
        
        if (!search_tag.blank?)
          pages = pages.select { |p| p.tags.include?(search_tag.downcase) }
        end
        
        if (!search_text.blank?)
          pages = pages.select { |p| "#{p.heading} #{p.text}" =~ /\b#{search_text}\b/i }
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