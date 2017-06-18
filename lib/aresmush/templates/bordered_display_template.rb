module AresMUSH
  class BorderedDisplayTemplate < ErbTemplateRenderer
          
    attr_accessor :text, :title, :subfooter, :subtitle, :leading_newline
    
    def initialize(text, title = nil, subfooter = nil, subtitle = nil, leading_newline = true)

      @text = text
      @title = title
      @subtitle = subtitle
      @subfooter = subfooter
      @leading_newline = leading_newline
      
      super File.dirname(__FILE__) + "/bordered_display.erb"
    end
    
    def title_line
      line = ""
      if (@leading_newline)
        line << "%r"
      end
      if (@title)
        line << "%xh#{title}%xn"
        line << "%r"
      end
      if (@subtitle)
        line << "%xh#{subtitle}%xn"
        line << "%r"
      end
      line
    end
  end
end
