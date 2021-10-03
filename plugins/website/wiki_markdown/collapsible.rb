module AresMUSH
  module Website
    class StartCollapsibleMarkdownExtension
      def self.regex
        /\[\[collapsible ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        button_text = matches[1]
        
        return "" if !button_text 
       
        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'collapsible.hbs'))
        
        data = {
          "button_text" => button_text,
          "id" => "col#{SecureRandom.uuid.gsub('-','')}"
        }
        
        template.render(data)        
      end
    end

    class EndCollapsibleMarkdownExtension
      def self.regex
        /\[\[\/collapsible\]\]/i
      end
      
      def self.parse(matches)
        "</div>"
      end
    end
  end
end