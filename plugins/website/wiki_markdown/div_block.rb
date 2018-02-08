module AresMUSH
  module Website
    class StartDivBlockMarkdownExtension
      def self.regex
        /(<p>)?(<br>)?\[\[div([^\]]*)\]\](<\/?br\/?>)?(<\/p>)?/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[3]
        "<div #{input}>"
      end
    end
    
    class EndDivBlockMarkdownExtension
      def self.regex
        /(<p>)?(<br>)?\[\[\/div\]\](<\/?br\/?>)?(<\/p>)?/i
      end
      
      def self.parse(matches, sinatra)
        "</div>"
      end
    end
  end
end