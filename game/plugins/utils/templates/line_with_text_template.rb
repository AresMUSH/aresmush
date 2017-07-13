module AresMUSH
  class LineWithTextTemplate < ErbTemplateRenderer
          
    attr_accessor :text
    
    def initialize(text)
      @text = text
      super File.dirname(__FILE__) + "/line_with_text.erb"
    end
    
    def right_border(padding_char)
      right('', 78 - 7 - text.length, '-')
    end
  end
end
