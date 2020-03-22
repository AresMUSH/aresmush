module AresMUSH

  class MushFormatter

    def self.format(msg, color_mode = "FANSI", screen_reader = false, ascii_mode = false)
      # Take escaped backslashes out of the equation for a moment because
      # they throw the other formatters off.
      msg = msg.gsub(/%\\/, "~ESCBS~")

      # Do substitutions
      msg = SubstitutionFormatter.format(msg, color_mode, screen_reader)

      if (!ascii_mode && !screen_reader && Global.read_config('emoji', 'allow_emoji'))
        msg = EmojiFormatter.format(msg)
      end
      
      # Unescape %'s
      msg = msg.gsub("\\%", "%")

      # Put the escaped backslashes back in.
      msg = msg.gsub("~ESCBS~", "\\")

      # Always end with ANSI reset & linebreak to flush output
      msg.chomp!
      msg = msg + ANSI.reset + "\r\n"
    end
    
  end
end
