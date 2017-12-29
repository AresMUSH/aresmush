module AresMUSH
  module Website
    class GetWikiPageRequestHandler
      def handle(request)
        name_or_id = request.args[:id]
        if (!name_or_id || name_or_id.blank?)
          name_or_id = 'home'
        end
      
        if (name_or_id =~ / /)
          name = name_or_id.gsub(' ', '-').downcase
        end
      
        page = WikiPage.find_by_name_or_id(name_or_id)
        if (!page)
          return { error: 'Page not found.'}
        end
        
        page_html = WebHelpers.format_markdown_for_html page.text
            
        {
          id: page.id,
          heading: page.display_title,
          title: page.title,
          name: page.name,
          html: page_html,
          tags: page.tags
        }
      end
    end
  end
end