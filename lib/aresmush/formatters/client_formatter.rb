module AresMUSH

  class ClientFormatter

    def self.format(msg)
      # Do substitutions
      msg = SubstitutionFormatter.format(msg)      
      # Ansify
      msg = AnsiFormatter.format(msg)
      # Unescape %'s
      msg = msg.gsub("\\%", "%")
      # Always end with ANSI reset & linebreak to flush output
      msg.chomp!
      msg = msg + ANSI.reset + "\r\n"
    end
    
  end
end
