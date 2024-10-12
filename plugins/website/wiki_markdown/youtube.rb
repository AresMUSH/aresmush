module AresMUSH
  module Website
    class YoutubeExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :video_id
                     
      def initialize(video_id)
        @video_id = video_id
        super File.dirname(__FILE__) + "/youtube.erb"        
      end   
    end
    
    class YoutubeMarkdownExtension
      def self.regex
        /\[\[youtube ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = YoutubeExtensionTemplate.new(input)
        template.render
      end
    end
  end
end