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
    
    def self.has_ansi?(str)
      str =~ code_regex
    end
    
    def self.format(str)
      return nil if str.nil?
      return str if !has_ansi?(str)

      formatted_str = ""
      groups = ansi_groups(str)
      groups.each do |g|
        if (g.start_with?("%"))
          formatted_str << get_code(g)
        else
          formatted_str << g
        end
      end
      
      formatted_str
    end
    
    # Given a string like %xb or %c102, returns the appropriate ansified string
    def self.get_code(ansi_str)
      matches = /^%(?<control>[XxCc])(?<code>.+)/.match(ansi_str)
      return ansi_str if matches.nil?
      
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
        return ansi_str
      end
    end

    def self.truncate(str, width)
      return nil if str.nil?
      return str.truncate(width) if !has_ansi?(str)
      groups = ansi_groups(str)
      keep = keep_groups_up_to_width(groups, width)
      keep[:groups].join
    end
        
    def self.center(str, width, pad_char = " ")
      return nil if str.nil?
      return str.truncate(width).center(width, pad_char) if !has_ansi?(str)
      groups = ansi_groups(str)
      keep = keep_groups_up_to_width(groups, width)
      length = keep[:length]
      fake_str = length.times.collect { "`" }.join
      formatted_str = fake_str.center(width, pad_char)
      formatted_str.gsub(fake_str, keep[:groups].join)
    end
    
    def self.left(str, width, pad_char = " ")
      return nil if str.nil?
      return str.truncate(width).ljust(width, pad_char) if !has_ansi?(str)
      groups = ansi_groups(str)
      keep = keep_groups_up_to_width(groups, width)
      length = keep[:length]
      fake_str = length.times.collect { "`" }.join
      formatted_str = fake_str.ljust(width, pad_char)
      
      formatted_str.gsub(fake_str, keep[:groups].join)
    end
    
    def self.right(str, width, pad_char = " ")
      return nil if str.nil?
      return str.truncate(width).rjust(width, pad_char) if !has_ansi?(str)
      groups = ansi_groups(str)
      keep = keep_groups_up_to_width(groups, width)
      length = keep[:length]
      fake_str = length.times.collect { "`" }.join
      formatted_str = fake_str.rjust(width, pad_char)
      formatted_str.gsub(fake_str, keep[:groups].join)
    end
    
    private
    
    def self.keep_groups_up_to_width(groups, width)
      # Not perfect (will count A%B as three chars), but close enough for the 
      # expected use cases.
      real_length = groups.select { |g| !g.start_with?("%") }.join.length
      return { :groups => groups, :length => real_length } if real_length <= width

      keep = []
      len = 0
      groups.each do |g|
        if (g.start_with?("%"))
          keep << g
        else
          group_length =  g.length
          if (len + group_length < width)
            keep << g
            len = len + group_length
          else
            keep << g.truncate(width - len)
            keep << "%xn"
            len = width
            break
          end
        end
      end
      { :groups => keep, :length => len }
    end
    
    def self.ansi_groups(str)
      str.split(code_regex)
    end
    
    def self.code_regex
      /((?<!\\)   # Not preceeded by backslash
      %[xXcC]     # Ansi code
      (?:         # Non-capturing group
        [A-Za-z]{1}|[\d]{1,3} # one letter, or 1-3 numbers
      )
      )  
      /x
    end
    
  end
end