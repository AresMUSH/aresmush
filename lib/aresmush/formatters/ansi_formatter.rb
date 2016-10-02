module AresMUSH
  class AnsiFormatter    
    def self.ansi_code_map
      {
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

        "n" => ANSI.reset,
        "N" => ANSI.reset

        # No, I did not forget 'blink'.  Blink is evil. :)
      }
    end
    
    # Given a string like %xb or %c102, returns the appropriate ansified string, 
    # or nil if ansi code is not valid.
    def self.get_code(str)
      matches = /^%(?<control>[XxCc])(?<code>.+)/.match(str)
      return nil if !matches
      
      control = matches[:control]
      code = matches[:code]
      
      if (ansi_code_map.has_key?(code))
        return ansi_code_map[code]
      elsif (code.to_i > 0 && code.to_i < 257)
        if (control == "X" || control == "C")
          return "\e[48;5;#{code}m"
        else
          return "\e[38;5;#{code}m"
        end
      else
        return nil
      end
    end
  end
end