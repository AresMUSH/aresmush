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
      "n" => ANSI.reset      
      }
      
      code_map.each_key do |code|
        str = str.gsub(/
            (?<!\\)      # Not escaped by a \
            (?:\\\\)*    # Unless the \ itself is part of an escaped \ seq
            \%c          # %c
            #{code}      # the code itself
            /x, 
            "#{code_map[code]}")    # Replace with the code's ansi value
      end
    
    str
  end
end