module AresMUSH
  module Website
    class SpotifyMarkdownExtension
      def self.regex
        /\[\[spotify ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'spotify.hbs'))
        linktype = "playlist"
        if (input.after(' ').strip == "track")
          linktype = "track"
        end

        data = {
          "code" => input.before(' '),
          "linktype" => linktype
        }
        
        template.render(data)
      end
    end
  end
end