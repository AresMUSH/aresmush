module AresMUSH
  module Website
    class StartPreBlockMarkdownExtension
      def self.regex
        /\[\[pre\]\]/i
      end
      
      def self.parse(matches)
        "\n<pre>\n"
      end
    end
    
    class EndPreBlockMarkdownExtension
      def self.regex
        /\[\[\/pre\]\]/i
      end
      
      def self.parse(matches)
        "\n</pre>\n"
      end
    end
  end
end