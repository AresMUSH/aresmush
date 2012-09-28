String.class_eval do
  def to_ansi
    str = self

    code_map = { 
      # TODO - See if there's a gray
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

    code_map.each_key do |code|
      str = str.gsub(/
      (?<!\\)           # Not preceded by a single backslash
      ((?:\\\\)*)       # Eat up any sets of double backslashes - match group 1  
      (%x#{code})       # Match the code itself - match group 2
      /x, 
      
      # Keep the double backslashes (group 1) then put in the code's ANSI value
      "\\1#{code_map[code]}")  
    end

    str
  end
end