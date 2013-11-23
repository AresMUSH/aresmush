module AresMUSH
  class Command
    
    # The command class will automatically cracks the two basic command formats:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    attr_accessor :raw, :root, :switch, :args
    
    def initialize(client, input)
      @client = client
      @raw = input   
      
      # TODO - Trigger externally         
      crack!(nil)
    end    
    
    def crack!(args_regex = nil)
      cracked = CommandCracker.crack(@raw)
      @root = cracked[:root]
      @switch = cracked[:switch]

      if (args_regex.nil?)
        @args = cracked[:args]
      else
        @args = ArgCracker.crack(args_regex, cracked[:args])        
      end
    end
    
    def to_s
      "Raw=#{@raw} #{@client}"
    end
    
    def root_is?(root)
      @root.upcase == root.upcase
    end
    
    def logged_in?
      @client.char != nil
    end
  
  end
end