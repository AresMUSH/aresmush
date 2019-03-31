module AresMUSH
  module Website
    class YoutubeMarkdownExtension
      def self.regex
        /\[\[youtube ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'youtube.hbs'))

        data = {
          "video_id" => input
        }
        
        template.render(data)
      end
    end
  end
end