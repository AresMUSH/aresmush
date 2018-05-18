module AresMUSH
  module Website
    class MusicPlayerMarkdownExtension
      def self.regex
        /\[\[musicplayer ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'music_player.hbs'))

        data = {
          "youtubecode" => input.before(' '),
          "description" => input.after(' '), 
          "id" => SecureRandom.uuid.gsub('-','')
        }
        
        template.render(data)
      end
    end
  end
end