module AresMUSH
  module Website
    class MusicPlayerMarkdownExtension
      def self.regex
        /\[\[musicplayer ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input


        template = ErbTemplateRenderer.new(File.join(File.dirname(__FILE__), 'music_player.erb'))
        data = {
          "youtubecode" => input.before(' '),
          "description" => input.after(' '), 
          "id" => SecureRandom.uuid.gsub('-','')
        }
        template.render_local data
      end
    end
  end
end