module AresMUSH
  class Command
    
    # The command class will automatically cracks the two basic command formats:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    attr_accessor :raw, :prefix, :root, :page, :switch, :args
    
    def initialize(input)
      @raw = input ? input.chomp.lstrip : nil
      crack!         
    end    
    
    def crack!
      cracked = CommandCracker.crack(@raw)
      @prefix = cracked[:prefix]
      @root = cracked[:root] ? cracked[:root].downcase : nil
      @page = cracked[:page]
      @switch = cracked[:switch] ? cracked[:switch].downcase : nil
      @args = cracked[:args]
    end
    
    def parse_args(args_regex)
      ArgParser.parse(args_regex, @args)
    end    
    
    def to_s
      "#{@raw}"
    end
    
    def root_is?(root)
      @root == root
    end
    
    def root_only?
      !@switch && !@args
    end
    
    def switch_is?(switch)
      @switch == switch
    end
  
    def root_plus_switch
      @switch ? "#{@root}/#{@switch}" : @root
    end
  end
end