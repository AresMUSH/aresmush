module AresMUSH
  module TemplateFormatters
    def line_with_text(text, style=nil)
      # This template is defined in the utils plugin so it can be customized.
      template = LineWithTextTemplate.new(text, style)
      template.render
    end
    
    def header
      "%lh"
    end
    
    def footer
      "%lf"
    end
    
    def divider
      "%ld"
    end
    
    def line(name)
      return Line.show(name)
    end
  end
end