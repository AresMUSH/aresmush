module AresMUSH
  class LineWithTextTemplate < ErbTemplateRenderer
          
    attr_accessor :text
    
    def initialize(text)
      @text = text
      super File.dirname(__FILE__) + "/line_with_text.erb"
    end
    
    def pad_char
       Global.read_config("skin", "line_with_text_padding") || '-'
    end
    
    def right_border
      right('', 78 - 9 - text.length, self.pad_char)
    end
    
    def color
      Global.read_config("skin", "line_with_text_color") || "%x!"
    end
    
    def left_border
      self.pad_char.repeat(5)
    end
  end
end
