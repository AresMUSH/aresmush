module AresMUSH
  module Website
    class GetBlankWikiPageRequestHandler
      def handle(request)
        title = request.args[:title] || ""
        tags = (request.args[:tags] || "").strip
        category = (request.args[:category] || "").strip
        template_name = (request.args[:template] || "").strip.downcase
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (template_name.blank?)
          template_name = "blank"
        end
                
        templates = Website.wiki_templates
        template = templates.select { |t| (t[:title]).strip == template_name }.first
        
        if (!category.blank?)
          name = "#{category}:#{WikiPage.sanitize_page_name(title)}"
        else
          name = nil
        end
        return { 
          not_found: true, 
          name: name,
          title: title.humanize.titleize,
          category: category,
          template: template || templates.select { |t| t[:title] == 'blank' }.first,
          tags: tags,
          templates: templates
         }        
      end
    end
  end
end