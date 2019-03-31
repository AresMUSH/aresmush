module AresMUSH
  module Website
    class PinterestMarkdownExtension
      def self.regex
        /\[\[pinterest ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'pinterest.hbs'))

        data = {
          "board_id" => input
        }
        
        template.render(data)
      end
    end
  end
end