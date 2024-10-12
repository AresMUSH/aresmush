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
    
    def truncate(str, width)
      return "" if !str
      SubstitutionFormatter.truncate(str, width)
    end
  end
end