module AresMUSH

  class ClientFormatter

    def self.format(msg, config_reader)
      # Do substitutions
      msg = SubstitutionFormatter.format(msg, config_reader)      
      # Ansify
      msg = AnsiFormatter.format(msg)
      # Unescape %'s
      msg = msg.gsub("\\%", "%")
      # Always end with ANSI reset & linebreak to flush output
      msg.chomp!
      msg = msg + ANSI.reset + "\n"
    end
    
  end
end
