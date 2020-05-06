module AresMUSH
  class SubstitutionFormatter
    
    def self.format(str, display_settings = ClientDisplaySettings.new)

      # Do the lines first in case they themselves have special chars in them
      # One crazy regex for efficiency's sake.  Looks for codes not preceded by a 
      # single backslash.
      str = str.gsub(/((?<!\\)%[l][hfdp12])/i) { |match| Line.show( match[2..-1], display_settings.screen_reader )}

      tokens = tokenize(str, display_settings)

      new_str = ""
      tokens.each do |t|
        new_str << t[:str]
      end
      new_str
    end
    
    def self.left(str, target_len, pad_char = " ")
      return nil if !str
       tokens = tokenize(str)
       trunc = truncate_tokenized(tokens, target_len)
       padding = pad_char.repeat(trunc[:remaining])
       "#{trunc[:str]}#{padding}"
    end
    
    def self.right(str, target_len, pad_char = " ")
      return nil if !str
       tokens = tokenize(str)
       trunc = truncate_tokenized(tokens, target_len)
       padding = pad_char.repeat(trunc[:remaining])
       "#{padding}#{trunc[:str]}"
    end
    
    def self.center(str, target_len, pad_char = " ")
      return nil if !str
       tokens = tokenize(str)
       trunc = truncate_tokenized(tokens, target_len)
       left_pad = pad_char.repeat((trunc[:remaining]/2.0).floor)
       right_pad = pad_char.repeat((trunc[:remaining]/2.0).ceil)
       "#{left_pad}#{trunc[:str]}#{right_pad}"
    end
    
    def self.truncate(str, target_len)
      return nil if !str
      tokens = tokenize(str)
      trunc = truncate_tokenized(tokens, target_len)
      "#{trunc[:str]}"
    end
    
    private
      
    def self.truncate_tokenized(tokens, target_len)
      new_str = ""
      len = 0
      tokens.each do |t|
        remaining = target_len - len
        if (t[:len] > remaining)
          new_str << t[:raw].truncate(remaining)
          len += remaining
        else
          new_str << t[:raw]
          len += t[:len]
        end
        
        if (len >= target_len)
          if (new_str =~ /\%x|\%c/)
            new_str << "%xn"
          end
          break
        end
      end

      remaining = target_len - len
      {
        :str => new_str,
        :len => len,
        :remaining => remaining
      }
    end
    
    def self.tokenize(str, display_settings = ClientDisplaySettings.new)
      str = "#{str}"
      code_regex = /
      (?<!\\)  # Not preceded by backslash
      (
        %[rR]  # Linebreaks
        |
        %[bB]  # Blank spaces
        |
        %[tT]  # Tabs
        |
        %\\    # Raw backslash
        |
        %[xXcC]!  # Random color
        |
        %[xXcC](?:[A-Za-z]{1}|[\d]{1,3})  # Ansi code - see AnsiFormatter about regex
        |
        \[left\([^\]]+\)\]
        |
        \[right\([^\]]+\)\]
        |
        \[center\([^\]]+\)\]
        |
        \[ansi\([^\]]+\)\]
        |
        \[space\([^\]]+\)\]
      )
      /x   # Allow regex to split across multiple lines

      tokens = []
      splits = str.split(code_regex)
      splits.each do |s| 
        tokens << token_for_substr(s, display_settings)
      end
      tokens
    end

    def self.token_for_substr(str, display_settings)
      case str
      when nil, ""
        return { :len => 0, :str => "", :raw => str }
      when "%R", "%r"
        return { :len => 0, :str => "\n", :raw => str }
      when "%B", "%b"
        return { :len => 1, :str => " ", :raw => str }
      when "%T", "%t"
        return { :len => 5, :str => "     ", :raw => str }
      when "%\\"
        return { :len => 1, :str => "\\", :raw => str }
      when "%x!", "%X!", "%c!", "%C!"
        ansi = "#{RandomColorizer.random_color}"
        return { :len => 0, :str => AnsiFormatter.get_code(ansi, display_settings.color_mode), :raw => str }
      end

      # Might be an ansi code
      if (str.start_with?("%"))
        ansi = AnsiFormatter.get_code(str, display_settings.color_mode)
        if (ansi)
          return { :len => 0, :str => ansi, :raw => str }
        end
      end

      # Might be a function.
      if (str.start_with?("["))
        if (str =~ /\[space\(([\d]+)\)\]/)
          return { :len => $1, :str => " ".repeat($1.to_i), :raw => str }
        elsif (str =~ /\[center\((.+)\,([\d]+)(?:\,(.+))?\)\]/)
          tmp = format($1)
          return { :len => $2, :str => center(tmp, $2.to_i, !$3 ? " " : $3), :raw => str }
        elsif (str =~ /\[left\((.+)\,([\d]+)(?:\,(.+))?\)\]/)
          tmp = format($1)
          return { :len => $2, :str => left(tmp, $2.to_i, !$3 ? " " : $3), :raw => str }
        elsif (str =~ /\[right\((.+)\,([\d]+)(?:\,(.+))?\)\]/)
          tmp = format($1)
          return { :len => $2, :str => right(tmp, $2.to_i, !$3 ? " " : $3), :raw => str }
        elsif (str =~ /\[ansi\((.+)\,(.+)\)\]/)
          raw_codes = $1.each_char.map { |c| "%x#{c}" }
          tmp = format($2)
          ansi = raw_codes.map { |c| AnsiFormatter.get_code(c, display_settings.color_mode) }.join
          return { :len => $2.length, :str => "#{ansi}#{tmp}#{ANSI.reset}", :raw => "#{raw_codes.join}#{tmp}%xn"}
        end
      end

      { :len => str.length, :str => str, :raw => str }
    end
  end
end

# Crazy test string for future reference
# "A fox jumped in%ch%xbblue%xn the %r%b%b%b%b%xhbrown%xn barn[space(10)] [center(X,5,@)]whee%xrred%xn then \\%xbnot\\%xn blue or \\[space(1)\\] with %x1ansi%xn %c234red%xn"