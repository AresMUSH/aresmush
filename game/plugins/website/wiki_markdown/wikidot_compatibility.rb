module AresMUSH
  module Website
    class WikidotExternalLinkMarkdownExtension
      def self.regex
        /[^`]\[http([^\] ]*) ([^\]]*)\]/i
      end
      
      def self.parse(matches, sinatra)
        url = matches[1]
        link_text = matches[2]

        return "" if !url || !link_text

        "[#{link_text}](http#{url})"
      end
    end
    
    class WikidotInternalLinkMarkdownExtension
      def self.regex
        /\[\[\[([^\]]*)\]\]\]/i
      end
      
      def self.parse(matches, sinatra)
        text = matches[1]
        return "" if !text

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
        
        url = url.downcase.gsub(' ', '-')
        if (url.start_with?("char:"))
          "<a href=\"/char/#{url.after(':')}\">#{link}</a>"
        else
          "<a href=\"/wiki/#{url}\">#{link}</a>"
        end
      end
    end
    
    class WikidotItalics
      def self.regex
       /\/\/([^\/\r\n]+)\/\//
      end
      
      def self.parse(matches, sinatra)
        text = matches[1]
        return "" if !text

        "<em>#{text}</em>"
      end
    end
    
    class WikidotHeading
      def self.regex
       /^([\+]+) /
      end
      
      def self.parse(matches, sinatra)
        heading = matches[1]
        return "" if !heading

        "##{heading.gsub("+", "#")} "
      end
    end
    
    class WikidotAnchor
      def self.regex
        /^\[\[#(.+)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        url = matches[1]
        return "" if !url

        "<a name=\"#{url.downcase.strip}\"></a>"
      end
    end    
  end
end