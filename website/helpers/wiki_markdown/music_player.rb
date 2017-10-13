module AresMUSH
  module Website
    class MusicPlayerMarkdownExtension
      def self.regex
        /\[\[musicplayer ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input

        sinatra.erb :"chars/music_player", :locals => { 
          youtubecode: input.before(' '), 
          description: input.after(' '),
          id: SecureRandom.uuid.gsub('-','') 
        }, :layout => false
      end
    end
  end
end