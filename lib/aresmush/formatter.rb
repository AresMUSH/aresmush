module AresMUSH
  module Formatter
    
    def self.config_reader=(reader)
      @@config_reader = reader
    end
    
    def self.config_reader
      @@config_reader
    end
    
    def self.parse_pose(name, msg)
      if msg.start_with?("\"")
        t('object.say', :name => name, :msg => msg.rest("\""))
      elsif msg.start_with?(":")
        t('object.pose', :name => name, :msg => msg.rest(":"))
      elsif msg.start_with?(";")
        t('object.semipose', :name => name, :msg => msg.rest(";"))
      elsif msg.start_with?("\\")
        msg.rest("\\")
      else
        msg
      end
    end
    
    # %r = linebreak
    # %t = 5 spaces
    # %~ = omit block marker
    # %l1 - %l4 - line1 through line4
    def self.perform_subs(str, model)
      # Do the lines first in case they themselves have special chars in them      
      str = str.code_gsub("%l1", config_reader.line("1"))
      str = str.code_gsub("%l2", config_reader.line("2"))
      str = str.code_gsub("%l3", config_reader.line("3"))
      str = str.code_gsub("%l4", config_reader.line("4"))
      
      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%~", "\u2682")
      str
    end
    
    # Randomly rotates between colors in a list, based on the seconds value of the current time.
    def self.random_color
      colors = [ 'c', 'b', 'g', 'r' ]
      bracket_width = 60 / colors.count
      index = Time.now.sec / bracket_width
      colors[index]
    end    
  end
end