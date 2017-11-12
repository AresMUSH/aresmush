module AresMUSH
  module TemplateFormatters
    def left(str, width, pad_char = " ")
      return "".ljust(width) if !str
      SubstitutionFormatter.left(str, width, pad_char)
    end

    def center(str, width, pad_char = " ")
      return "".ljust(width) if !str
      SubstitutionFormatter.center(str, width, pad_char)
    end

    def right(str, width, pad_char = " ")
      return "".rjust(width) if !str
      SubstitutionFormatter.right(str, width, pad_char)
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
    
    def line_with_text(text)
      # This template is defined in the utils plugin so it can be customized.
      template = LineWithTextTemplate.new(text)
      template.render
    end
    
    # This works with Erubis templates; now depracated.
    def one_line(&block)
      str = capture(&block)
      @output << str.gsub(/\n/, "")
      @output << "\n" if str.ends_with? "\n"
      return ""
    end
  
    # This works with Erubis templates; now depracated.
    def capture(*args)
      old_buffer = @output
      @output = ""
      yield(*args)
      new_buffer = @output
      @output  = old_buffer
      new_buffer
    end
  end
end