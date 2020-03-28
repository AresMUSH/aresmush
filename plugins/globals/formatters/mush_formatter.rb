module AresMUSH

  class MushFormatter

    def self.format(msg, display_settings = ClientDisplaySettings.new)
      if (display_settings.ascii_mode)
        msg = self.downgrade_to_ascii(msg)
      end

      # Take escaped backslashes out of the equation for a moment because
      # they throw the other formatters off.
      msg = msg.gsub(/%\\/, "~ESCBS~")

      # Do substitutions
      msg = SubstitutionFormatter.format(msg, display_settings)

      if (display_settings.show_emoji && Global.read_config('emoji', 'allow_emoji'))
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
    
    def self.downgrade_to_ascii(msg)
      # Replace smart quotes/apostrophes with regular ones and replace other non-ascii chars with '?'
      msg.gsub(/[\u201c\u201d]/, '"')
               .gsub(/[\u2018\u2019]/, "'")
               .encode("ASCII", invalid: :replace, undef: :replace, replace: '?')
    end
    
  end
end
