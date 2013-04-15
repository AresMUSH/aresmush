module AresMUSH
  class Command
    
    # The command class will automatically cracks the two basic command formats:
    #   root[/switch][ args]
    #   root[args, when args starts with a number]
    # Anything not found will be nil
    attr_accessor :raw, :root, :switch, :args
    
    def initialize(client, input)
      @client = client
      @raw = input.chomp
      crack(input)
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
    
    def crack_args!(regex)
      match = regex.match(@args)
      @args = match.nil? ? HashReader.new({}) : HashReader.new(match.names_hash)
    end
    
    def can_crack_args?(regex)
      return regex.match(@args)
    end
    
    private
    
    def crack(input)
      cracked = /^(?<root>[^\d\s\/]+)(?<switch>\/[^\s]+)*(?<args>.+)*/.match(input.strip)
      @root = cracked[:root].nil? ? nil : cracked[:root].strip
      @switch = cracked[:switch].nil? ? nil : cracked[:switch].rest("/")
      @args = cracked[:args].nil? ? nil : cracked[:args].strip
    end
  end
end