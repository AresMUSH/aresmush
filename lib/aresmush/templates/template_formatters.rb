module AresMUSH
  module TemplateFormatters
    def left(str, width, pad_char = " ")
      return "".ljust(width) if str.nil?
      SubstitutionFormatter.left(str, width, pad_char)
    end

    def center(str, width, pad_char = " ")
      return "".ljust(width) if str.nil?
      SubstitutionFormatter.center(str, width, pad_char)
    end

    def right(str, width, pad_char = " ")
      return "".rjust(width) if str.nil?
      SubstitutionFormatter.right(str, width, pad_char)
    end
    
    def line(number = 1)
      "%l#{number}"
    end
    
    def line_with_text(text)
      padding = "-"
      left_spacer = " ["
      right_spacer = "] "
      
      str = "#{left_spacer}#{text}#{right_spacer}"
      "%x!#{left('', 5, padding)}" +
         "#{center(str, 25, padding)}" +
         "#{right('', 48, padding)}"
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