module AresMUSH
  module Website
    class SpotifyExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :code, :linktype
                     
      def initialize(code, linktype)
        @code = code
        @linktype = linktype
        super File.dirname(__FILE__) + "/spotify.erb"        
      end   
    end
    
    class SpotifyMarkdownExtension
      def self.regex
        /\[\[spotify ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        linktype = "playlist"
        if (input.after(' ').strip == "track")
          linktype = "track"
        end
        
        code = input.before(' ')
        template = SpotifyExtensionTemplate.new(code, linktype)      
        template.render
      end
    end
  end
end