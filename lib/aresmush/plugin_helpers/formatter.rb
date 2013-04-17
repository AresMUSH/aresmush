module AresMUSH
  module Formatter

    def self.config_reader=(reader)
      @@config_reader = reader
    end

    def self.config_reader
      @@config_reader
    end

    def self.format_client_output(msg)
      # Do substitutions
      msg = perform_subs(msg)      
      # Ansify
      msg = to_ansi(msg)
      # Unescape %'s
      msg = msg.gsub("\\%", "%")
      # Always end with ANSI reset & linebreak to flush output
      msg.chomp!
      msg = msg + ANSI.reset + "\n"
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
    def self.perform_subs(str)
      # Do the lines first in case they themselves have special chars in them
      # TODO! This is UGLY!              
      str = str.code_gsub("%l1", config_reader.line("1"))
      str = str.code_gsub("%l2", config_reader.line("2"))
      str = str.code_gsub("%l3", config_reader.line("3"))
      str = str.code_gsub("%l4", config_reader.line("4"))

      str = str.code_gsub("%[rR]", "\n")
      str = str.code_gsub("%[tT]", "     ")
      str = str.code_gsub("%~", "\u2682")
      str = str.code_gsub("%x!", "%x#{random_color}")
      str
    end

    # Randomly rotates between colors in a list, based on the seconds value of the current time.
    def self.random_color
      colors = [ 'c', 'b', 'g', 'r' ]
      bracket_width = 60 / colors.count
      index = Time.now.sec / bracket_width
      colors[index]
    end     
    
    def self.to_ansi(str)
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