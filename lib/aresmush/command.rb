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
      
      # TODO - Move to crack method, trigger externally
      cracked = CommandCracker.crack(input)
      @root = cracked[:root]
      @switch = cracked[:switch]
      @args = cracked[:args]
    end
    
    # TODO - Move to crack method
    def crack_args!(regex)
      @args = ArgCracker.crack(regex, @args)
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