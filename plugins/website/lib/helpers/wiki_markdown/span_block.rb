module AresMUSH
  module Website
    class StartSpanBlockMarkdownExtension
      def self.regex
        /\[\[span([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input

        "<span #{input}>"
      end
    end
    
    class EndSpanBlockMarkdownExtension
      def self.regex
        /\[\[\/span\]\]/i
      end
      
      def self.parse(matches, sinatra)
        "</span>"
      end
    end
  end
end