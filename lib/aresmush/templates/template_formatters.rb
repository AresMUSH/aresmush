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
      line_config = Global.read_config("skin", "line_with_text")
      template = line_config["template"]
      padding = line_config["padding"]
      left_spacer = line_config["left_spacer"]
      right_spacer = line_config["right_spacer"]
      width = line_config["width"]
      
      str = "#{left_spacer}#{text}#{right_spacer}"
      template.gsub(/text/, center(str, width, padding))
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