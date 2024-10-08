module AresMUSH
  module Website
    
    class ImageExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :source, :style, :align, :url, :title
                     
      def initialize(source, style, align, url, title)
        @source = source
        @style = style
        @align = align
        @url = url
        @title = title
        
        super File.dirname(__FILE__) + "/image.erb"        
      end      
    end
    
    class ImageMarkdownExtension
      def self.regex
        /\[\[image ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input
        
        style = ""
        source = ""
        align = ""
        url = ""
        options = input.split(' ')
        options.each do |opt|
          option_name = opt.before('=') || ""
          option_value = opt.after('=') || ""
        
          case option_name.downcase.strip
          when 'width'
            style << " width:#{option_value};"
          when 'height'
            style << " height:#{option_value};"
          when 'center', 'left', 'right'
            align = opt.strip
          when 'source', 'src'
            source = option_value.strip
          when 'url', 'link'
            url = option_value.strip
          else
            source = opt.strip
          end
        end
      
        source = source.downcase.strip
        if (!source.start_with?('/game/uploads'))
          source = "/game/uploads/#{source}"
        end
        
        parts = source.gsub("/game/uploads/", "").split("/")
        folder = parts[0]
        name = parts[1]
        file_meta = WikiFileMeta.find_meta(folder, name)
        title = file_meta ? file_meta.description : ''
        
        if url.blank?
          url = "/file/#{folder}/#{name}"
        end
        
        template = ImageExtensionTemplate.new(source, style, align, url, title)
        template.render
      end
    end
  end
end
