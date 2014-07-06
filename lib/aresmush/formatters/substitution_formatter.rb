module AresMUSH
  class SubstitutionFormatter
    # %r = linebreak
    # %t = 5 spaces
    # %~ = omit block marker
    # %l1 - %l4 - line1 through line4
    def self.format(str)
      # Do the lines first in case they themselves have special chars in them
      str = str.code_gsub("%l1", Line.show("1"))
      str = str.code_gsub("%l2", Line.show("2"))
      str = str.code_gsub("%l3", Line.show("3"))
      str = str.code_gsub("%l4", Line.show("4"))

      str = str.code_gsub("%[bB]", " ")
      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%~", "\u2682")
      str = str.code_gsub("%x!", "%x#{RandomColorizer.random_color}")
      str
    end
    
  end
end
