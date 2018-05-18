module AresMUSH
  module Website
    class StartSpanBlockMarkdownExtension
      def self.regex
        /\[\[span([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        "<span #{input}>"
      end
    end
    
    class EndSpanBlockMarkdownExtension
      def self.regex
        /\[\[\/span\]\]/i
      end
      
      def self.parse(matches)
        "</span>"
      end
    end
  end
end