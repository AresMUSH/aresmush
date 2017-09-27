module AresMUSH
  module Website
    class StartDivBlockMarkdownExtension
      def self.regex
        /\[\[div([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        "<div #{input}>"
      end
    end
    
    class EndDivBlockMarkdownExtension
      def self.regex
        /\[\[\/div\]\]/i
      end
      
      def self.parse(matches, sinatra)
        "</div>"
      end
    end
  end
end