module AresMUSH
  class SubstitutionFormatter
    # %r = linebreak
    # %t = 5 spaces
    # %l1 - %l4 - line1 through line4
    def self.format(str)
      # Do the lines first in case they themselves have special chars in them
      str = str.code_gsub("%[lL]1", Line.show("1"))
      str = str.code_gsub("%[lL]2", Line.show("2"))
      str = str.code_gsub("%[lL]3", Line.show("3"))
      str = str.code_gsub("%[lL]4", Line.show("4"))

      str = str.gsub(/(?<!\\)\[space\(([\d]+)\)\]/) { |num| Regexp.last_match[1].to_i.times.collect { '%B' }.join }
      str = str.code_gsub("%[bB]", " ")
      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%x!", "%x#{RandomColorizer.random_color}")
      str
    end
  end
end
