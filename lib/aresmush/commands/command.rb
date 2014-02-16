module AresMUSH
  class Command
    
    # The command class will automatically cracks the two basic command formats:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    attr_accessor :raw, :prefix, :root, :switch, :args
    
    def initialize(input)
      @raw = input
      crack!         
    end    
    
    def crack!(args_regex = nil)
      cracked = CommandCracker.crack(@raw)
      @prefix = cracked[:prefix]
      @root = cracked[:root]
      @switch = cracked[:switch]

      if (args_regex.nil?)
        @args = cracked[:args]
      else
        @args = ArgCracker.crack(args_regex, cracked[:args])        
      end      
    end
    
    def to_s
      "Raw=#{@raw.chomp} #{@client}"
    end
    
    def root_is?(root)
      @root.upcase == root.upcase
    end
    
    def root_only?
      @switch.nil? && @args.nil?
    end
  
  end
end