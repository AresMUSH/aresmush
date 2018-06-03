module AresMUSH
  module Website
    class CategoryListMarkdownExtension
      def self.regex
        /\[\[categoryList ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        category = matches[1]
        return "" if !category

        matches = WikiPage.all.select { |p| p.category && (p.category.downcase == category.downcase) }
        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'page_list.hbs'))

        data = {
          "pages" => matches.sort_by { |m| m.title }.map { |m| {heading: m.heading, name: m.name} }
        }
        
        template.render(data)
      end
    end
  end
end
