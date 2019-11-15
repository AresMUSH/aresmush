module AresMUSH
  module Website
    class GetBlankWikiPageRequestHandler
      def handle(request)
        title = request.args[:title] || ""
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        
        id = WikiPage.sanitize_page_name(title)
        return { 
          not_found: true, 
          title: title.humanize.titleize,
          templates: Website.wiki_templates
         }        
      end
    end
  end
end