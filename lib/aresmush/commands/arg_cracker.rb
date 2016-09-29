module AresMUSH  
  class ArgCracker
    
    # Performs advanced cracking on command arguments, given a custom regex.
    
    def self.crack(regex, args)
      match = regex.match(args)
      !match ? HashReader.new({}) : HashReader.new(match.names_hash)
    end
    
    def self.can_crack_args?(regex, args)
      return regex.match(args)
    end
  end
end