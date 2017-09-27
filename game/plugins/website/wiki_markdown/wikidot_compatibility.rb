module AresMUSH
  module Website
    class WikidotExternalLinkMarkdownExtension
      def self.regex
        /[^`]\[http([^\] ]*) ([^\]]*)\]/i
      end
      
      def self.parse(matches, sinatra)
        url = matches[1]
        link_text = matches[2]
        "[#{link_text}](http#{url})"
      end
    end
    
    class WikidotInternalLinkMarkdownExtension
      def self.regex
        /\[\[\[([^\]]*)\]\]\]/i
      end
      
      def self.parse(matches, sinatra)
        text = matches[1]
        if (text =~ /\|/)
          url = text.before('|')
          link = text.after('|')
        else
          url = text
          link = text
        end
        
        if (link =~ /:/)
          link = link.after(":")
        end
        
        "<a href=\"/wiki/#{url}\">#{link}</a>"
      end
    end
    
    class WikidotItalics
      def self.regex
       /\/\/([^\/\r\n]+)\/\//
      end
      
      def self.parse(matches, sinatra)
        text = matches[1]
        "<em>#{text}</em>"
      end
    end
  end
end