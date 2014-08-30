module AresMUSH
  class SubstitutionFormatter
    # %r = linebreak
    # %t = 5 spaces
    # %l1 - %l4 - line1 through line4
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

      # Take escaped backslashes out of the equation for a moment.
      str = str.gsub(/%\\\\/, "~ESCBS~")

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
          "%x!" => "%x#{RandomColorizer.random_color}"
        },
        )

      # Put the escaped backslashes back in.
      str = str.gsub("~ESCBS~", "\\")
      str
    end
  end
end
