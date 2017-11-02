module AresMUSH

  class MushFormatter

    def self.format(msg, enable_fansi = true)
      # Take escaped backslashes out of the equation for a moment because
      # they throw the other formatters off.
      msg = msg.gsub(/%\\/, "~ESCBS~")

      # Do substitutions
      msg = SubstitutionFormatter.format(msg, enable_fansi)

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
