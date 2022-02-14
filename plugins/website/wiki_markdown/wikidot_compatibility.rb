module AresMUSH
  module Website
    class WikidotExternalLinkMarkdownExtension
      def self.regex
        /\[http([^\] ]*) ([^\]]*)\]/i
      end
      
      def self.parse(matches)
        url = matches[1]
        link_text = matches[2]

        return "" if !url || !link_text

        "[#{link_text}](http#{url})"
      end
    end
    
    class WikidotHtml
      def self.regex
        /\[\[\/?html\]\]/i
      end
      
      def self.parse(matches)
        ""
      end
    end
    
    class WikidotInternalLinkMarkdownExtension
      def self.regex
        /\[\[\[([^\]]*)\]\]\]/i
      end
      
      def self.parse(matches)
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
        
        if (url.start_with?("char:"))
          "<a href=\"/char/#{url.after(':')}\">#{link}</a>"
        else
          if (url =~ /\#/)
            anchor = url.after("#")
            url = url.before("#")
            url = WikiPage.sanitize_page_name(url)
            "<a href=\"/wiki/#{url}##{anchor}\">#{link}</a>"
          else
            url = WikiPage.sanitize_page_name(url)
            "<a href=\"/wiki/#{url}\">#{link}</a>"
          end
        end
      end
    end
    
    class WikidotItalics
      def self.regex
       /([^:])\/\/([^\/\r\n]+)\/\//
      end
      
      def self.parse(matches)
        prefix = matches[1]
        text = matches[2]
        return "" if !text

        "#{prefix}<em>#{text}</em>"
      end
    end
    
    class WikidotHeading
      def self.regex
       /^([\+]+) /
      end
      
      def self.parse(matches)
        heading = matches[1]
        return "" if !heading

        "##{heading.gsub("+", "#")} "
      end
    end
    
    class WikidotCenter
      def self.regex
        /\[\[=\]\]/
      end
      
      def self.parse(matches)
        "[[div class=\"centered\"]]"
      end
    end
    
    class WikidotEndCenter
      def self.regex
       /\[\[\/=\]\]/
      end
      
      def self.parse(matches)
        "[[/div]]"
      end
    end
    
    class WikidotAnchor
      def self.regex
        /^\[\[#(.+)\]\]/i
      end
      
      def self.parse(matches)
        url = matches[1]
        return "" if !url

        "<a name=\"#{url.downcase.strip}\"></a>"
      end
    end    
  end
end