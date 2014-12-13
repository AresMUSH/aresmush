module AresMUSH
  class SubstitutionFormatter
    
    def self.format2(str)

      # Do the lines first in case they themselves have special chars in them
      # One crazy regex for efficiency's sake.  Looks for codes not preceded by a 
      # single backslash.
      str = str.gsub(/((?<!\\)%[lL][1234])/, 
      {
        "%l1" => Line.show("1"),
        "%L1" => Line.show("1"),
        "%l2" => Line.show("2"),
        "%L2" => Line.show("2"),
        "%l3" => Line.show("3"),
        "%L3" => Line.show("3"),
        "%l4" => Line.show("4"),
        "%L4" => Line.show("4")
        })

      tokens = tokenize(str)

      new_str = ""
      tokens.each do |t|
        new_str << t[:str]
      end
      new_str
    end
    
    def self.format(str)
       
      # Do the lines first in case they themselves have special chars in them
      # One crazy regex for efficiency's sake.  Looks for codes not preceded by a 
      # single backslash.
      str = str.gsub(/((?<!\\)%[lL][1234])/, 
      {
        "%l1" => Line.show("1"),
        "%L1" => Line.show("1"),
        "%l2" => Line.show("2"),
        "%L2" => Line.show("2"),
        "%l3" => Line.show("3"),
        "%L3" => Line.show("3"),
        "%l4" => Line.show("4"),
        "%L4" => Line.show("4")
        })
      str = str.gsub(/\[space\(([\d]+)\)\]/) { |num| Regexp.last_match[1].to_i.times.collect { ' ' }.join }
      str = str.gsub(/\[center\((.+)\,([\d]+)\)\]/) { |num| Regexp.last_match[1].center(Regexp.last_match[2].to_i) }
      str = str.gsub(/(?<!\\)(%[xXcC](?:[A-Za-z]{1}|[\d]{1,3}))/) { |num| AnsiFormatter.get_code(Regexp.last_match[1]) }
      
      # Same kind of crazy regex as before, for efficiency.
      str = str.gsub(/
      ((?<!\\)%[bB])|
      ((?<!\\)%[rR])|
      ((?<!\\)%[tT])|
      ((?<!\\)%\\)|
      ((?<!\\)%x!)
      /x, # Lets the regex be spread out over multiple lines.
      {
        "%b" => " ",
        "%B" => " ",
        "%r" => "\n",
        "%R" => "\n",
        "%t" => "     ",
        "%T" => "     ",
        "%\\" => "\\",
        "%x!" => AnsiFormatter.get_code("%x#{RandomColorizer.random_color}")
      }
      )

      str
    end
    
    def self.left(str, chars, padding = " ")
      str.nil? ? "" : format(str).ljust(chars, padding)
    end
    
    def self.right(str, chars, padding = " ")
      str.nil? ? "" : format(str).rjust(chars, padding)
    end
    
    def self.center(str, chars, padding = " ")
      str.nil? ? "" : format(str).center(chars, padding)
    end
    
    def self.tokenize(str)
      code_regex = /
      (?<!\\)  # Not preceded by backslash
      (
        %[rR]  # Linebreaks
        |
        %[bB]  # Blank spaces
        |
        %[tT]  # Tabs
        |
        %\\    # Raw backslash
        |
        %[xXcC]!  # Random color
        |
        %[xXcC](?:[A-Za-z]{1}|[\d]{1,3})  # Ansi code - see AnsiFormatter about regex
        |
        \[[^\]]+\]   # Functions like space and center
      )
      /x   # Allow regex to split across multiple lines

      tokens = []
      splits = str.split(code_regex)
      splits.each do |s| 
        tokens << token_for_substr(s)
      end
      tokens
    end

    def self.token_for_substr(str)
      case str
      when nil, ""
        return { :len => 0, :str => "" }
      when "%R", "%r"
        return { :len => 0, :str => "\n" }
      when "%B", "%b"
        return { :len => 1, :str => " " }
      when "%T", "%t"
        return { :len => 5, :str => "     " }
      when "%\\"
        return { :len => 1, :str => "\\" }
      when "%x!", "%X!", "%c!", "%C!"
        ansi = "%x#{RandomColorizer.random_color}"
        return { :len => 0, :str => AnsiFormatter.get_code(ansi) }
      end

      # Might be an ansi code
      if (str.start_with?("%"))
        ansi = AnsiFormatter.get_code(str)
        if (ansi)
          return { :len => 0, :str => ansi }
        end
      end

      # Might be a function.
      if (str.start_with?("["))
        str = str.gsub(/\[space\(([\d]+)\)\]/) { |num| Regexp.last_match[1].to_i.times.collect { ' ' }.join }
        str = str.gsub(/\[center\((.+)\,([\d]+)\)\]/) { |num| Regexp.last_match[1].center(Regexp.last_match[2].to_i) }
      end

      { :len => str.length, :str => str }
    end
  end
end
