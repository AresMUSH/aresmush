class String
    
  def first(sep)
    parts = self.partition(sep)  # Returns [head, sep, tail]
    return parts[0]
  end

  def rest(sep)
    parts = self.partition(sep)        # Returns [head, sep, tail]
    return parts[0] if parts[1] == ""  # sep empty if not found
    return parts[2]
  end  
  
  def to_ansi
    str = self

    code_map = { 
      "x" => ANSI.black,
      "r" => ANSI.red,
      "g" => ANSI.green,
      "y" => ANSI.yellow,
      "b" => ANSI.blue,
      "m" => ANSI.magenta,
      "c" => ANSI.cyan,
      "w" => ANSI.white,

      "X" => ANSI.on_black,
      "R" => ANSI.on_red,
      "G" => ANSI.on_green,
      "Y" => ANSI.on_yellow,
      "B" => ANSI.on_blue,
      "M" => ANSI.on_magenta,
      "C" => ANSI.on_cyan,
      "W" => ANSI.on_white,

      "u" => ANSI.underline,
      "h" => ANSI.bold,
      "i" => ANSI.inverse,
      
      "U" => ANSI.underline_off,
      "I" => ANSI.inverse_off,
      "H" => ANSI.bold_off,

      "n" => ANSI.reset

      # No, I did not forget 'blink'.  Blink is evil. :)

    }

    # Ugly regex to find/replace ansi codes.  Will replace %x?, except when escaped (\%x?)
    # unless of course the escaping backslash is part of a larger escape sequence (\\%x?)
    code_map.each_key do |code|
      str = str.gsub(/
      (?<!\\)           # Not preceded by a single backslash
      ((?:\\\\)*)       # Eat up any sets of double backslashes - match group 1  
      (%x#{code})       # Match the code itself - match group 2
      /x, 
      
      # Keep the double backslashes (match group 1) then put in the code's ANSI value
      "\\1#{code_map[code]}")  
    end

    # Do an ANSI reset at the end to prevent ansi "bleeding" in case there's a non-terminated code.
    str + ANSI.reset
  end
  
  # Fairly crude - doesn't worry about helper words or anything.  Should suffice for MUSH purposes.
  def titlecase
    self.gsub(/\b('?[a-z])/) { $1.capitalize }
  end      
end