module AresMUSH
  module Website
    
    class MusicPlayerExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :youtubecode, :description, :id
                     
      def initialize(youtubecode, description)
       @youtubecode = youtubecode
       @description = description
       @id = SecureRandom.uuid.gsub('-','')
        
        super File.dirname(__FILE__) + "/music_player.erb"        
      end      
    end
    
    class MusicPlayerMarkdownExtension
      def self.regex
        /\[\[musicplayer ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        youtubecode = input.before(' ')
        description = input.after(' ')

        template = MusicPlayerExtensionTemplate.new(youtubecode, description)
        template.render
      end
    end
  end
end