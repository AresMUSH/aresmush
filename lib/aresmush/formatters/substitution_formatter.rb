module AresMUSH
  class SubstitutionFormatter
    def self.config_reader=(reader)
      @@config_reader = reader
    end
    
    def self.config_reader
      @@config_reader
    end
    
    # %r = linebreak
    # %t = 5 spaces
    # %~ = omit block marker
    # %l1 - %l4 - line1 through line4
    def self.format(str)
      # Do the lines first in case they themselves have special chars in them
      # TODO! This is UGLY!              
      str = str.code_gsub("%l1", config_reader.line("1"))
      str = str.code_gsub("%l2", config_reader.line("2"))
      str = str.code_gsub("%l3", config_reader.line("3"))
      str = str.code_gsub("%l4", config_reader.line("4"))

      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%~", "\u2682")
      str = str.code_gsub("%x!", "%x#{RandomColorizer.random_color}")
      str
    end
    
  end
end
