module AresMUSH
  module Website
    class PinterestExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :board_id
                     
      def initialize(board_id)
       @board_id = board_id
        super File.dirname(__FILE__) + "/pinterest.erb"        
      end      
    end
    
    class PinterestMarkdownExtension
      def self.regex
        /\[\[pinterest ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        template = PinterestExtensionTemplate.new(input)
        template.render
      end
    end
  end
end