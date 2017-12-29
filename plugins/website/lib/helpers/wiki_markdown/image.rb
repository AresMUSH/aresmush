module AresMUSH
  module Website
    class ImageMarkdownExtension
      def self.regex
        /\[\[image ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input
        
        style = ""
        source = ""
        align = ""
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
          else
            source = opt.strip
          end
        end
      
        source = source.downcase.strip
        if (!source.start_with?('/uploads'))
          source = "/uploads/#{source}"
        end
        
        template = ErbTemplateRenderer.new(File.join(File.dirname(__FILE__), 'image.erb'))
        data = {
          "source" => source,
          "style" => style, 
          "align" => align
        }
        template.render_local data
      end
    end
  end
end
