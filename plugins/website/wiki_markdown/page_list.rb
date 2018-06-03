module AresMUSH
  module Website
    class PageListMarkdownExtension
      def self.regex
        /\[\[pagelist ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        helper = TagMatchHelper.new(input)

        matches = WikiPage.all.select { |p| 
          ((p.tags & helper.or_tags).any? && 
          (p.tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & p.tags == helper.required_tags) 
        }

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'page_list.hbs'))

        data = {
          "pages" => matches.sort_by { |m| m.title }.map { |m| {heading: m.heading, name: m.name} }
        }
        
        template.render(data)
      end
    end
  end
end
