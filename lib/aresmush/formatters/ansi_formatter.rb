module AresMUSH
  class AnsiFormatter
    def self.format(str)
      ansi_code_map = { 
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
      if (str.index("%x") || str.index("%c"))
        ansi_code_map.each_key do |code|
          str = str.code_gsub("%[xX]#{code}", ansi_code_map[code])
          str = str.code_gsub("%[cC]#{code}", ansi_code_map[code])
        end
      end
      str
    end
  end
end