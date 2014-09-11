module AresMUSH
  class Command
    
    # The command class will automatically cracks the two basic command formats:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    attr_accessor :raw, :prefix, :root, :page, :switch, :args
    
    def initialize(input)
      @raw = input
      crack!         
    end    
    
    def crack!
      cracked = CommandCracker.crack(@raw)
      @prefix = cracked[:prefix]
      @root = cracked[:root]
      @page = cracked[:page]
      @switch = cracked[:switch]
      @args = cracked[:args]
    end
    
    def crack_args!(args_regex)
      @args = ArgCracker.crack(args_regex, @args)        
    end
    
    def to_s
      "#{@raw.chomp}"
    end
    
    def root_is?(root)
      @root.upcase == root.upcase
    end
    
    def root_only?
      @switch.nil? && @args.nil?
    end
    
    def switch_is?(switch)
      return false if @switch.nil?
      @switch.upcase == switch.upcase
    end
  
  end
end